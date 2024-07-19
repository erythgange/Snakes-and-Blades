extends Line2D

var queue: Array = []
var max_length = 10


func _process(delta) -> void:
	var pos = get_parent().global_position
	
	queue.push_front(pos)
	if queue.size() > max_length:
		queue.pop_back()
	clear_points()
	for point in queue:
		add_point(point)
	

