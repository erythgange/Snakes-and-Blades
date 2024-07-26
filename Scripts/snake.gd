extends CharacterBody2D

# Base values
var health: int = 50
var current_body_count: int = 1
var speed: float = 100
var max_speed: float = current_body_count * 100
var global_position_last: Vector2 = global_position

# Stat Modifiers (additive values)
var bonus_speed: float = 0
var bonus_turn_speed: int = 0
var charge: float = 0

# States
var is_dashing: bool = false
var is_dash_on_cooldown: bool = false

var is_blade_on_left_side: bool = true
var is_slashing: bool = false
var is_blade_on_cooldown: bool = false

var is_parrying: bool = false
var is_parry_on_cooldown: bool = false

var can_update_body: bool = true
var can_speedup: bool = true
var is_snake_healed: bool = false
var is_snake_damaged: bool = false

# Scenes to instantiate/duplicate (i.e. the body and the tail)
var snake_body = preload("res://Scenes/snake_body.tscn")

# animations 
@onready var blade_animation = $Blade/BladeAnimation
@onready var blade_parry = $Blade/BladeParry
@onready var hit_flash = $HitFlash
@onready var snake_head_sprite = $SnakeHeadSprite
@onready var popup_number_position = $PopupNumbersOrigin

# timers and cooldowns
@onready var parry_cooldown = $Blade/ParryCooldown
@onready var parry_duration = $Blade/ParryDuration
@onready var blade_cooldown = $Blade/BladeCooldown
@onready var dash_cooldown =  $Blade/DashCooldown
@onready var update_body_cooldown = $UpdateBodyCooldown

# array containers 
var position_history = []
var rotation_history = []
var body_parts = []
var gap: int = 2


# this function runs every frame. so 60 times per second or more.
func _physics_process(delta) -> void:	
	
	_create_body()
	# (to be implemented) randomize instantiate food
	_update_body()
	# (to be implemented) if collided with food: heal, food deleted
	_attack()
	_parry()
	
	#Turn left or right + slight speed boost (for moving like a snake!)
	var turn_speed: int = speed/2 + 100
	if Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		rotate(deg_to_rad( -(turn_speed + bonus_turn_speed) * delta) )
		speed += 0.001
	if Input.is_action_pressed("Right") and not Input.is_action_pressed("Left"):
		rotate(deg_to_rad( (turn_speed + bonus_turn_speed) * delta) )
		speed += 0.001
	
	# speed manager
	velocity = Vector2((speed+bonus_speed),0).rotated(rotation)
	# gains speed over time limited by current_body_count
	max_speed = current_body_count * 100
	if speed < max_speed and can_speedup == true:
		speed += (health * 0.002)
	
	# collide effects: bounce and if -1 if not parrying
	var collision = move_and_collide(velocity*delta)
	if !(collision == null): #if collided
		# (to be implemented) if angle is less than 10 or speed < 200, rotate and slide
		var bounce = (velocity.bounce(collision.get_normal()) + global_position )
		look_at(bounce)
		
		if is_parrying == true: # if collided while parrying:
			parry_cooldown.stop()
			parry_cooldown.emit_signal("timeout") # resets parry cooldown
			# play success parry animation
		else: # if collided while not parrying:
			_hurt(10, true) # 10 damage when colliding
			speed = speed*0.75 # 75% speed loss when colliding
			if speed < 50: speed = 50 # minimum speed
			print(velocity)
	else: move_and_slide()
	
	
	
func _create_body():
		# stores position_history every 1 distance traveled of snake (instead of every frame)
	if (global_position_last.distance_to(global_position)) > current_body_count/10 + 10:
		global_position_last = global_position
		position_history.append(global_position)
		rotation_history.append(global_rotation)
		
	# snake cant grow past the health value
	if position_history.size() > current_body_count*10:
		position_history.pop_front()
	
	#move body parts
	if position_history.size() > body_parts.size()*gap:
		for x in body_parts.size():
			var point = -1-(x*gap)
			body_parts[x].global_position = lerp(body_parts[x].global_position, position_history[point], .5)
			body_parts[x].global_rotation = lerp_angle(body_parts[x].global_rotation, rotation_history[point], .8)

func _update_body():

	print(current_body_count)
	if health/10 > current_body_count:
		can_update_body = false
		current_body_count += 1
		var snake_body = snake_body.instantiate()
		snake_body.global_position = global_position
		body_parts.append(snake_body)
		add_sibling(snake_body)
	if health/10 < current_body_count:
		can_update_body = false
		current_body_count -= 1
		body_parts.pop_back()
			

func _ready():
	print("running func _ready():")

func _hurt(damage: int, is_collision: bool):
	PopupNumbers.display_number(damage, popup_number_position.global_position, true)
	hit_flash.play("hit_flash")
	# hit stun the snake
	if is_collision == true and health < 1: health = 1 # cant die in collision
	else: health -= damage
			
func _heal(heal: int):
	PopupNumbers.display_number(heal, popup_number_position.global_position, false)
	hit_flash.play("hit_flash")
	health += heal

func _on_update_body_cooldown_timeout():
	can_update_body = true
	print("Snake Healed!")
	
func _parry():
	if is_parry_on_cooldown == false and Input.is_action_just_pressed("Parry"):
		parry_cooldown.start()
		is_parry_on_cooldown = true
		can_speedup = false
		
		parry_duration.start(speed/500) # parry duration = based on speed
		blade_parry.play("blade_parry") # start animation
		is_parrying = true
		print(is_parrying)
			
func _attack():
	# Charge and Dash + animations
	if is_dash_on_cooldown == false and is_blade_on_cooldown == false:
		# dash is pressed Charge from 0 up to 10.
		if Input.is_action_pressed("Dash") and charge < 10:
			charge += .1
			if is_blade_on_left_side == true: 
				blade_animation.play("blade_charge")
			else: blade_animation.play("blade_charge_mirror")
			speed -= (speed*0.001)
			can_speedup = false
		# dash released
		if Input.is_action_just_released("Dash"):
			#Dash if charge reaches 3/10
			if charge > 3:
				if is_blade_on_left_side == true: 
					blade_animation.play("blade_dash")
				else: blade_animation.play("blade_dash_mirror")
				dash_cooldown.start()
				is_dash_on_cooldown = true
				is_dashing = true
				
				bonus_speed = speed * 2
				bonus_turn_speed = -10
				print("Dashed!")     

			# if less than 3 charge, play a basic animation
			else: 
				if is_blade_on_left_side == true: 
					blade_animation.play("blade_neutral_attack")
				else: blade_animation.play("blade_neutral_attack_mirror")
				blade_cooldown.start()
				is_blade_on_cooldown = true
				print("blade on cooldown")
				charge = 0
		
			#if blade is on left: swich to right (viceversa)
			if is_blade_on_left_side == true:
				is_blade_on_left_side = false
			else: is_blade_on_left_side = true
			
	# Converts charge values to bonus speed until it runs out
	elif charge > 0 and is_dashing == true: 
		bonus_speed -= bonus_speed*0.05
		charge -= 0.5
		# Return to original values
		if charge <= 0: 
			if is_blade_on_left_side == false: blade_animation.play("blade_recovery")
			else: blade_animation.play("blade_recovery_mirror")
			is_dashing = false
			can_speedup = true
			bonus_speed = 0
			bonus_turn_speed = 0
	
func _on_dash_cooldown_timeout():
	is_dash_on_cooldown = false
	print("dash cooldown false")
	
func _on_blade_cooldown_timeout():
	is_blade_on_cooldown = false
	can_speedup = true
	
func _on_parry_cooldown_timeout():
	is_parry_on_cooldown = false
	can_speedup = true
	print("parry cooldown timeout!")

func _on_parry_duration_timeout():
	is_parrying = false
	blade_parry.play("RESET")
	print("parry duration timeout!")






