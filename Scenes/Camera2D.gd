extends Camera2D

var center: Vector2 = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if owner.has_node("SnakeHead"):
		var snake1 = $"../SnakeHead/CameraMarker".global_position
		var center = snake1
		global_position = snake1
		
	if owner.has_node("SnakeHead") and owner.has_node("SnakeHead2"):
		var snake1 = $"../SnakeHead/CameraMarker".global_position
		var snake2 = $"../SnakeHead2/CameraMarker".global_position
		var center = snake1.lerp(snake2, 0.5)
		global_position = center
		var distance = snake1.distance_to(snake2)
		var zoomxy = 1.1 - (distance * .0005)
		zoom = Vector2(zoomxy, zoomxy)
