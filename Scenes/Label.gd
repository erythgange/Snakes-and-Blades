extends Label


func _process(delta):
	pass



func start():
	visible = true
	await get_tree().create_timer(1).timeout
	text = 3
	await get_tree().create_timer(1).timeout
	text = 2
	await get_tree().create_timer(1).timeout
	text = 1
	await get_tree().create_timer(1).timeout
	text = 0
	#change scene
	

