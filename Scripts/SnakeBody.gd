extends CharacterBody2D


@onready var target = %SnakeHead

func _physics_process(delta):
	
	velocity = $"..".global_position - global_position
	if (global_position.distance_to(target.global_position)) > 30:
		velocity = target.global_position - global_position
	
	
	move_and_slide()
