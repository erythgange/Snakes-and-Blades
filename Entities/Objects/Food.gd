extends RigidBody2D

func _ready() -> void:
		linear_velocity = Vector2( randf_range(-1,1)*100, randf_range(-1,1)*100)
		angular_velocity = randf_range(-1,1)*10
