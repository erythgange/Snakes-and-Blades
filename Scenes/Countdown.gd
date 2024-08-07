extends Label


func _physics_process(delta): update_label_text()
func update_label_text(): text = str(ceil($Timer.time_left))
func start():
	visible = true
	$Timer.start()
func _on_timer_timeout(): 
	get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
