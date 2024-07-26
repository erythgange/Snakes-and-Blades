extends CharacterBody2D


var debug = preload("res://Scenes/debug.tscn")
var timer = true
var bounce: Vector2

func _physics_process(delta):
	
	velocity = Vector2(10,0).normalized().rotated(rotation) * 100

	var collision = move_and_collide(velocity*delta)
	if !(collision == null): # and if speed is h0-igh
		var bounce = (velocity.bounce(collision.get_normal()) + global_position )
		look_at(bounce)
	else: move_and_slide()
	

func _on_timer_timeout():
	timer = true

func _debug(pos):
	var debug = debug.instantiate()
	debug.global_position = pos
	add_sibling(debug)
