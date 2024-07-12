extends CharacterBody2D

# Base values
@export var health = 10
@export var speed = 100

# Variables
@export var max_speed = health*100
@export var turn = (speed/10) + 200

# Bonus variables
@export var bonus_speed = 0
@export var bonus_turn_speed = 0
@export var charge = 0

# States
var is_dashing: bool = false
var is_slashing: bool = false
var is_parrying: bool = false
var can_speedup: bool = true

@onready var dash_cooldown = $DashCooldown

func _physics_process(delta):

	# gains speed with max limit
	if speed < max_speed and can_speedup == true: 
		speed += health * 0.05 

	# Dash
	if Input.is_action_pressed("Dash"):
		charge += .1
	if Input.is_action_just_released("Dash"):
		if charge > 5:
			print ("dashing!")
			$DashTime.start()
			is_dashing = true
			bonus_speed = 1000
		charge = 0
		
	
	# Rotates snake head with left or right
	if Input.is_action_pressed("Left"):
		rotate(deg_to_rad( -(turn + bonus_turn_speed) * delta) )
	if Input.is_action_pressed("Right"):
		rotate(deg_to_rad( (turn + bonus_turn_speed) * delta) )
		
	
	
	# Speed = Movement speed with a max capacity
	velocity = Vector2(speed+bonus_speed,0).rotated(rotation) 
	#velocity = velocity.limit_length(max_speed)
	
	# Debug print
	print(charge)
	
	move_and_slide()





func _on_dash_time_timeout():
	is_dashing = false
	bonus_speed = 0
