extends RigidBody2D

var ball_speed: Vector2 = Vector2(randf_range(-1,1), -randf_range(-1,1)) * 100


func _physics_process(delta):
	
	var collision_info = move_and_collide(ball_speed * delta)
	if collision_info:
		ball_speed = ball_speed.bounce(collision_info.get_normal())
		
