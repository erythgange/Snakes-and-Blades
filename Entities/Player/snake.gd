extends CharacterBody2D

# Base values (can be changed)
@export_range(1,100) var health: int = 20 #min: 10, max: 100

# Stat Modifiers (additive values)
var bonus_speed: float = 0
var bonus_turn_speed: int = 0

# States
var can_speedup: bool = true

# animations 

@onready var blade_parry = $Blade/BladeParry
@onready var hit_flash = $HitFlash
@onready var snake_head_sprite = $SnakeHeadSprite

@onready var camera = $Camera2D

# Scenes to instantiate/duplicate (i.e. the body and the tail)
var snake_body = preload("res://Entities/Player/snake_body.tscn")


# array containers
var position_history = []
var rotation_history = []
var body_parts = []

# values that should not be changed huhu otherwise shit will break
@export var controls: Resource = null
var index: int
var global_position_last: Vector2 = global_position
var max_speed: float
var speed: float
var turn_amplifier: float = 1
var gap: int = 2








# this function runs every frame. so 60 times per second or more.
func _physics_process(delta) -> void:
	# clone body based on number of health
	_create_body()
	
	# add or remove body
	_update_body()
	
	# attack, dash and parry
	_dash(delta)
	
	# Turn left and right
	var turn_speed: int = (speed +150) * turn_amplifier
	_turn(turn_speed, delta)
	
	# collision and bounce
	var collision = move_and_collide(velocity*delta) # bounce when collided
	_bounce(collision)
	
	
			

	
		
	# speed manager
	velocity = Vector2((speed+bonus_speed),0).rotated(rotation) * delta * 100
	var max_speed = body_parts.size() * 20
	if speed < max_speed and can_speedup == true:
		speed += (health * .5) * delta
	$CameraMarker.position.x = (speed+bonus_speed)*.1
	



func _ready():
	# snake sprites per player
	var index = controls.player_index
	$SnakeHeadSprite.region_rect = Rect2(0, (index-1)*16, 16, 16)
	$SnakeHeadGlow.region_rect = Rect2(48, (index-1)*16, 16, 16)
	# player collision
	_set_by_player_collisions()
	
func _set_by_player_collisions() -> void:
	$Hitbox.set_collision_layer_value(controls.blade_layer, true) # you have this blade
	$Hitbox.set_collision_mask_value(controls.snake_layer, false) # your blade cannot see this snake
	$Hurtbox.set_collision_layer_value(controls.snake_layer, true) # you are this snake
	

@onready var popup_numbers = preload("res://Scenes/PopupNumbers.tscn")
@onready var popup_number_position = $PopupNumbersOrigin

func _popup_numbers(value: int, is_damage: bool, is_parry: bool) -> void:
	var number = popup_numbers.instantiate()
	add_sibling(number)
	number.global_position = popup_number_position.global_position
	number.display_numbers(value, is_damage, is_parry)
	
	


# Game Feel and Movement
const particle_bounce = preload("res://Particles/bounce.tscn")
const BOUNCE_PARRY = preload("res://Particles/bounce_parry.tscn")
func _bounce(collision) -> void:
	if !(collision == null): #if collided
		# (to be implemented) if angle is less than 10 or speed < 200, rotate and slide
		var bounce = (velocity.bounce(collision.get_normal()) + global_position )
		look_at(bounce)
		if is_parrying == true: # if collided while parrying:
			_spawn_particle(BOUNCE_PARRY, global_position)
			speed += 20
			bonus_speed += speed/5
			$DashParticles.emitting = true
			_popup_numbers((speed+bonus_speed)/5, false, true)
		else: # if collided while not*** parrying:
			_hurt((speed+bonus_speed)/5, true, speed) # damage when colliding
			_spawn_particle(particle_bounce, collision.get_position())
			speed = speed*0.50 #speed loss when colliding
			bonus_speed = 0
			if speed < 35: speed = 35 # minimum speed	

func _create_body() -> void:
	# stores position_history reference for body to move to. higher values = shorter snake
	if (global_position_last.distance_to(global_position)) > (15 - ((speed+bonus_speed) / 50)):
		global_position_last = global_position
		position_history.append(global_position)
		rotation_history.append(global_rotation)
	#move body parts
	if position_history.size() > body_parts.size()*gap:
		for x in body_parts.size():
			var point = -2-(x*(gap))
			body_parts[x].global_position = lerp(body_parts[x].global_position, position_history[point], .6)
			body_parts[x].global_rotation = lerp_angle(body_parts[x].global_rotation, rotation_history[point], .6)

var hitstun: bool = false
func _update_body():
	if health/5 > body_parts.size():
		var snake_body = snake_body.instantiate()
		var index = controls.player_index
		snake_body.get_node("SnakeBodySprite").region_rect = Rect2(16, (index-1)*16, 16, 16)
		snake_body.get_node("SnakeBodyGlow").region_rect = Rect2(32, (index-1)*16, 16, 16)
		if !body_parts.is_empty(): 
			snake_body.global_position = body_parts[-1].position
			snake_body.global_rotation = body_parts[-1].rotation
			snake_body.connect("cut", Callable(self, "sliced"))
			snake_body.body_part_number = body_parts.size()
		body_parts.append(snake_body)
		snake_body._set_collision(controls.snake_layer, controls.blade_layer)
		add_sibling(snake_body)
		
	# remove body if there is body to remove
	elif health/5 < body_parts.size() and not body_parts.is_empty():
		var left_body_part = body_parts[-1]
		body_parts.pop_back()
		left_body_part._detached(speed+(bonus_speed/2))
		var force = speed+(bonus_speed/2) * 5
		left_body_part.linear_velocity = Vector2(randf_range(-1,1) * force, randf_range(-1,1) * force)
		left_body_part.angular_velocity = randf_range(-1,1) * force

func sliced(body_part_number) -> void:
	if invulnerable == false:
		invulnerable = true
		var sliced_count = (body_parts.size() - body_part_number)
		
		#hitstun = true
		for x in sliced_count:
			body_parts[body_parts.size() - sliced_count + x]._hit_flash()
			_hitstun(1, 0)
			print("hit stun!")
		var damage = sliced_count * 3
		health -= damage
		_popup_numbers(damage, true, false)
		_hitstun(0, damage/2)
		await get_tree().create_timer(1, true, false, false).timeout
		invulnerable = false
			
func _turn(turn_speed, delta) -> void:
	if Input.is_action_pressed(controls.left):
		rotate(deg_to_rad( -(turn_speed) * delta) )
	if Input.is_action_pressed(controls.right):
		rotate(deg_to_rad( (turn_speed) * delta) )

func _hitstun(time, shake) -> void:
	Engine.time_scale = 0.1
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1
	$"../Camera2D"._camera_shake(shake)
	
var invulnerable: bool = false
# Heal and Hurt
func _hurt(damage: int, is_collision: bool, speed: float) -> void:
	if is_parrying == true:
		_spawn_particle(BOUNCE_PARRY, global_position)
		_popup_numbers((speed+bonus_speed)/5, false, true)
	else:
		if invulnerable == false:
			invulnerable = true
			turn_amplifier = 0
			hit_flash.play("hit_flash_long")
			for x in body_parts.size():
				if damage < 20: body_parts[x]._hit_flash()
				else:
					_hitstun(.00001, 0)  # hitstun if more than 20 damage
					body_parts[x]._hit_flash()
				await get_tree().create_timer(.00001).timeout
			if is_collision == true and (health - damage) <= 0: damage = health-1 # lives on 1hp
			# snake cant grow past the health value
			if position_history.size() > (body_parts.size()+1) *2: position_history.pop_front()
			health -= damage # damage for collision
			_popup_numbers(damage, true, false)
			if health < 1: _die()
			if damage > 20: _hitstun(0, damage/2)

			
			
			await get_tree().create_timer(.5, true, false, false).timeout
			turn_amplifier = 1
			hit_flash.play("RESET")
			invulnerable = false

var can_die: bool = true
func _die() -> void:
	if can_die == true:
		self.queue_free()
		$".."._game_over(controls.player_index)
	else: _hurt(0,true,0)

func _heal(heal: int) -> void:
	if (heal + health) > 100:
		heal = 100 - health
	health += heal
	# sfx
	_popup_numbers(heal, false, false)
	hit_flash.play("hit_flash")
	
# Attack and Dash
var charge: float = 0
var blade_delay: float = -10
var is_sword_onleft: bool = true
var is_parrying: bool = false
var can_parry: bool = true
var can_dash: bool = true
var can_attack: bool = true
@onready var blade = $Blade
@onready var blade_sprite = $Blade/BladeSprite
@onready var shine = $Blade/Shine
@onready var blade_anim = $Blade/BladeAnimations
@onready var dash_particles = $DashParticles
const slash = preload("res://Particles/slash.tscn")
func _dash(delta) -> void:
	
	if can_attack == true:
		if blade_delay > -10: 
			blade_delay -= 5 * delta
			
		if blade_delay < 0:
			if Input.is_action_just_pressed(controls.dash):
				can_speedup = false
				_parry()
			if Input.is_action_pressed(controls.dash):
				if is_sword_onleft == true: blade_anim.play("charge")
				else: blade_anim.play("charge_mirror")
				# charge and dash
				if charge >= 1:
					if bonus_speed < 0:
						$Hitbox/HitboxShape.position.x = (speed+bonus_speed) *.7
						bonus_speed = speed
						dash_particles.emitting = true
						dash_particles.amount = speed/2
				elif charge < 1: 
					
					bonus_speed -= delta * (speed+bonus_speed) * 2
					charge += 1 * delta
				turn_amplifier = 0.1
				
			elif bonus_speed > 0: bonus_speed -= delta * 100

			if Input.is_action_just_released(controls.dash):
				if bonus_speed < 0: bonus_speed = 0

				blade_delay += 6
				turn_amplifier = 1
				charge = 0
				_slash()
				_spawn_particle(slash, global_position)
				$Hitbox/HitboxShape.position.x = 0
				is_parrying = false
			
func _slash() -> void:
	if is_sword_onleft == true: blade_anim.play("Neutral")
	else: blade_anim.play_backwards("Neutral")
	is_sword_onleft = !is_sword_onleft
	$Blade/BladeSprite.flip_h = !$Blade/BladeSprite.flip_h
	can_speedup = true
		
func _parry() -> void:
	blade_sprite.material.set_shader_parameter("enabled", true)
	is_parrying = true
	shine.emitting = true
	
	var parrytimer = ((bonus_speed/4) + speed)/1000 + .2
	print (parrytimer)
	await get_tree().create_timer(parrytimer).timeout
	blade_sprite.material.set_shader_parameter("enabled", false)
	
	shine.emitting = false
	is_parrying = false


func _spawn_particle(instantiate, pos):
	var instance = instantiate.instantiate()
	instance.global_position = global_position
	instance.global_rotation = global_rotation
	instance.scale = scale
	add_sibling(instance)
	instance.start(speed+bonus_speed, is_sword_onleft, pos)
	
