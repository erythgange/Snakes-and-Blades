extends CharacterBody2D

var offset = 10

func _physics_process(delta) -> void:
	var target_position = get_parent().global_position
	
	if global_position.distance_to(target_position) < offset: 
		return	
	velocity = (target_position - global_position).normalized() * 2

	move_and_slide()
