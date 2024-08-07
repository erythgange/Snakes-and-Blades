extends Camera2D

var center: Vector2 = global_position
var random_strength: float = 30
var shake_fade: float = 5
var shake_strength: float = 0
var rng = RandomNumberGenerator.new()

func _physics_process(delta) -> void:	
	$Debug.text = "FPS: " + str(Engine.get_frames_per_second())
	if Input.is_action_just_pressed("debug"): 
		_camera_shake(5)
		if $Debug.visible == false: $Debug.visible = true
		else: $Debug.visible = false
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
	
# camera shake when taking damage/parrying
func _camera_shake(amount):
	shake_strength = amount 

# zoom when winning a round
func _wipeout_screen() -> void:
	pass
