extends Label

var time_left: int = 30


func _process(delta):
	pass



func _on_timer_timeout():
	if time_left > 0:
		time_left -= 1
		self.text = str(time_left)
