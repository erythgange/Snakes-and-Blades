extends CPUParticles2D

func _ready():
	if emitting == false:
		queue_free()
			
func start(speed) -> void:
	#emitting = true
	#initial_velocity_max = speed
	#amount = speed/5
	pass
