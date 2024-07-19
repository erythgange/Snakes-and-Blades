extends CharacterBody2D

# Base values
@export var health: int = 100
@export var current_body_count: int = 1
@export var speed: float = 100
@export var max_speed: float = health * 10
@export var turn: float = (speed/100) + 150

# Stat Modifiers (additive values)
@export var bonus_speed: float = 0
@export var bonus_turn_speed: float = 0
@export var charge: float = 0

# States
var run_once: bool = false
var is_dashing: bool = false
var is_dash_on_cooldown: bool = false
var is_slashing: bool = false
var is_blade_on_left_side: bool = true
var is_blade_on_cooldown: bool = false
var is_parrying: bool = false
var can_speedup: bool = true
var is_snake_healed: bool = false
var is_snake_damaged: bool = false
var is_collission: bool

# Scenes to instantiate/duplicate (i.e. the body and the tail)
var snake_hitzone = preload("res://Scenes/snake_hitzone.tscn")

# References to other nodes
@onready var blade_animation = $Blade/BladeAnimation
@onready var blade_cooldown = $Blade/BladeCooldown
@onready var dash_cooldown =  $Blade/DashCooldown
@onready var snake_head_sprite = $SnakeHeadSprite

# array containers 
var position_history = []
var rotation_history = []
var body_position = [] 








func _physics_process(delta) -> void:

	#position_history.append(global_position)
	

		
	

	# gains speed with max limit
	if speed < max_speed and can_speedup == true: 
		speed += (health * 0.005)

	# Charge and Dash + animations
	if is_dash_on_cooldown == false and is_blade_on_cooldown == false:
		# True if dash is pressed Charge from 0 up to 10.
		if Input.is_action_pressed("Dash") and charge < 10:
			charge += .1
			if is_blade_on_left_side == true: blade_animation.play("blade_charge")
			else: blade_animation.play("blade_charge_mirror")
			speed -= (speed*0.001)
			can_speedup = false
			
		# True if dash is released
		if Input.is_action_just_released("Dash"):
			#Dash if charge reaches 3/10
			if charge > 3:
				
				if is_blade_on_left_side == true: blade_animation.play("blade_dash")
				else: blade_animation.play("blade_dash_mirror")
				dash_cooldown.start()
				is_dash_on_cooldown = true
				is_dashing = true
				
				bonus_speed = speed * 2
				bonus_turn_speed = -100
				print("Dashed!")

			# if less than 3 charge, play a basic animation
			else: 
				if is_blade_on_left_side == true: blade_animation.play("blade_neutral_attack")
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
		speed += 0.01
	if Input.is_action_pressed("Right") and not Input.is_action_pressed("Left"):
		rotate(deg_to_rad( (turn + bonus_turn_speed) * delta) )
		speed += 0.01

	# Physics process end
	velocity = Vector2(0,-(speed+bonus_speed)).rotated(rotation)
	snake_head_sprite.rotation = deg_to_rad(velocity.angle())
	move_and_slide()

	if (position_history[-1] - global_position) 
		position_history.pop_back()

	



func create_hitzone():
	var new_instance = snake_hitzone.instantiate()
	new_instance.global_position = global_position
	position_history.append(global_position)
	add_sibling(new_instance) 

func _ready():
	print("running func _ready():")
	current_body_count = health

func hurt(damage, is_collission):
	health -= damage
	# damage pop-up
	# play entity flash animation
	# hit stun the snake
	if is_collission == true and health == 1: # can't die in collission
		return
	else: for x in damage: 
		pass # execute this x amount of times the damage
			# remove_child
			
func heal(amount):
	health += amount
	# heal pop-up
	# play entity flash animation
	
func _on_dash_cooldown_timeout():
	is_dash_on_cooldown = false
	print("dash cooldown false")
	
func _on_blade_cooldown_timeout():
	print (position_history)
	is_blade_on_cooldown = false
	can_speedup = true
	print("blade refreshed")
	
