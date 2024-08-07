extends RigidBody2D

func _ready() -> void:
		var tween = create_tween()
		linear_velocity = Vector2( randf_range(-1,1)*20, randf_range(-1,1)*20)
		angular_velocity = randf_range(-1,1)*20 * .1
