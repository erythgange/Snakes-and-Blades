extends Control

@onready var panel_container = $ColorRect
@onready var v_box_container = $VBoxContainer
var paused = false

func _ready() -> void:
	self.visible = false
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _process(delta) -> void: 
	if $"../..".has_node("Logo"): pass
	elif Input.is_action_just_pressed("esc"): _pause_menu()
	
func _pause_menu() -> void:
	if paused:
		self.visible = false
		Engine.time_scale = 1
	else:
		self.visible = true
		Engine.time_scale = 0
	paused = !paused # vice versa
		
func _on_quit_to_desktop_pressed(): get_tree().quit()
func _on_resume_pressed(): _pause_menu()
func _on_fullscreen_toggled(toggled_on):
	if toggled_on == true: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

