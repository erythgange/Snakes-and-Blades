extends CharacterBody2D

var distance_threshold = 50
# if no child = becomes tail, else becomes body


func _physics_process(delta):
	var parent_position = get_parent().global_position
	var to_parent = global_position.distance_to(parent_position)
	
	position.y = 5
	
	global_position = global_position - parent_position
	global_rotation = get_parent().global_rotation
	
	#print (get_parent().global_rotation)
	
	if to_parent < distance_threshold:
		return
	
	#position = parent_position 
	move_and_slide()
