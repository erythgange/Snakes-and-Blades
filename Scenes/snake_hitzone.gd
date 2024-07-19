extends Area2D

var seconds: int

func lifetime(seconds):
	await get_tree().create_timer(seconds).timeout
	queue_free()
