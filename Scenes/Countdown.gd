extends Label

func _ready(): 
	set_physics_process(false)
	
func _physics_process(delta): 
	update_label_text()
	
func update_label_text(): 
	text = "Match in " + str(ceil($Timer.time_left))

func start():
	set_physics_process(true)
	visible = true
	$Timer.start()
	
func _on_timer_timeout(): 
	$"../Camera2D/FadetoBlack/Transition".play("fade_to_black")
	preload("res://Scenes/Arena.tscn")
	
func _on_transition_animation_finished(fade_to_black):
	get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
