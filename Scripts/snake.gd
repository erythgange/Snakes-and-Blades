extends CharacterBody2D

# Base values
@export var health: int = 100
@export var current_body_count: int = 1
@export var speed: float = 100
@export var max_speed: float = current_body_count * 100
@export var turn: float = (speed/10) + 200


var global_position_last: Vector2 = global_position

# Stat Modifiers (additive values)
@export var bonus_speed: float = 0
@export var bonus_turn_speed: float = 0
@export var charge: float = 0

# States
var run_once: bool = true
var is_dashing: bool = false
var is_dash_on_cooldown: bool = false
var is_slashing: bool = false
var is_blade_on_left_side: bool = true
var is_blade_on_cooldown: bool = false
var is_parrying: bool = false
var can_speedup: bool = true
var can_grow_body: bool = true
var is_snake_healed: bool = false
var is_snake_damaged: bool = false


# Scenes to instantiate/duplicate (i.e. the body and the tail)
var snake_body = preload("res://Scenes/snake_body.tscn")

# References to other nodes
@onready var blade_animation = $Blade/BladeAnimation
@onready var blade_cooldown = $Blade/BladeCooldown
@onready var dash_cooldown =  $Blade/DashCooldown
@onready var snake_head_sprite = $SnakeHeadSprite
@onready var heal_cooldown = $HealCooldown
# array containers 
var position_history = []
var rotation_history = []
var body_parts = []




var gap: int = 2


# this function runs every frame. so 60 times per second or more.
func _physics_process(delta) -> void:	

	if run_once == true: _run_once()
	
	
	
	
	# stores position_history every 1 distance traveled of snake (instead of every frame)
	if (global_position_last.distance_to(global_position)) > current_body_count:
		global_position_last = global_position
		position_history.append(global_position)
		rotation_history.append(global_rotation)
		
	# snake cant grow past the health value
	if position_history.size() > current_body_count*10:
		position_history.pop_front()
	#move body parts
	
	
	for x in body_parts.size():
		var point = min(-1-(x*gap), position_history.count(-1))
		body_parts[x].global_position = lerp(body_parts[x].global_position, position_history[point], .8)
		body_parts[x].global_rotation = lerp_angle(body_parts[x].global_rotation, rotation_history[point], .8)
		
		
	# Healing
	# if eat food, heal health
	if can_grow_body == true and health/10 > current_body_count:
		heal_cooldown.start()
		can_grow_body = false
		current_body_count += 1
		_grow_body()
	
	
	
	print (speed)
	print (current_body_count)





	# gains speed with max limit
	max_speed = current_body_count * 100
	if speed < max_speed and can_speedup == true: 
		speed += (health * 0.002)

	# Charge and Dash + animations
	if is_dash_on_cooldown == false and is_blade_on_cooldown == false:
		# True if dash is pressed Charge from 0 up to 10.
		if Input.is_action_pressed("Dash") and charge < 10:
			charge += .1
			if is_blade_on_left_side == true: 
				blade_animation.play("blade_charge")
			else: blade_animation.play("blade_charge_mirror")
			speed -= (speed*0.001)
			can_speedup = false
			
		# True if dash is released
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
				bonus_turn_speed = -100
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

	# Turn left or right + slight speed boost (for moving like a snake!)
	if Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		rotate(deg_to_rad( -(turn + bonus_turn_speed) * delta) )
		speed += 0.001
	if Input.is_action_pressed("Right") and not Input.is_action_pressed("Left"):
		rotate(deg_to_rad( (turn + bonus_turn_speed) * delta) )
		speed += 0.001

	# Physics process end
	velocity = Vector2(0,-(speed+bonus_speed)).rotated(rotation)
	snake_head_sprite.rotation = deg_to_rad(velocity.angle())
	move_and_slide()


	


func _grow_body():
	var snake_body = snake_body.instantiate()
	snake_body.global_position = global_position
	body_parts.append(snake_body)
	add_sibling(snake_body)

func _ready():
	print("running func _ready():")
	
func _run_once():
	run_once = false

func _hurt(damage: int, is_collission: bool):
	health -= damage
	# damage pop-up
	# play entity flash animation
	# hit stun the snake
	if is_collission == true and health == 1: # can't die in collission
		return
	else: for x in damage: 
		pass # execute this x amount of times the damage
			# remove_child
			
func _heal(amount):
	health += amount
	# heal pop-up
	# play entity flash animation	
	
func _on_dash_cooldown_timeout():
	is_dash_on_cooldown = false
	print("dash cooldown false")
	
func _on_blade_cooldown_timeout():
	is_blade_on_cooldown = false
	can_speedup = true
	

func _on_heal_cooldown_timeout():
	can_grow_body = true
	print("Snake Healed!")
