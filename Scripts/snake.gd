extends CharacterBody2D

@export var Health = 10
@export var Speed = 500
@export var maxSpeed = Health*100
@export var Turn = Speed
#States: 1 = Neutral, 2 = Dashing, 3 = Parrying
@export var State = 1

@onready var timer = $Timer

func _physics_process(delta):
	
	if Speed < maxSpeed and State == 1:
		Speed += Health * .05
	
	
	velocity = Vector2(Speed,0).rotated(rotation)
	velocity = velocity.limit_length(maxSpeed)
	
	if State == 1:
		Turn = (Speed/10) + 100
	else: Turn = (Speed/10) + 150
	
	if Input.is_action_pressed("Left"):
		rotate(deg_to_rad(-Turn*delta))
	if Input.is_action_pressed("Right"):
		rotate(deg_to_rad(Turn*delta))

	

	#print(Speed)
	move_and_slide()
