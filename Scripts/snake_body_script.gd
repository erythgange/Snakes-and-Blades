extends CharacterBody2D

var update_timer: bool = false

func _physics_process(delta):
	#var parent_position = get_parent().global_position
	#var to_parent = global_position.distance_to(parent_position)
	
	#position.y = 5
	
	#global_position = global_position - parent_position
	if update_timer == false:
		$UpdateTimer.start()
		update_timer = true
		global_rotation = get_parent().global_rotation
	
	#position = parent_position 
	move_and_slide()



func _on_update_timer_timeout():
	update_timer = false
