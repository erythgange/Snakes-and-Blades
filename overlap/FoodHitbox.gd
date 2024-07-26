extends Area2D

@export var value: int = 10

func _on_area_entered(area):
	if area.owner.has_method("_heal"):
		area.owner._heal(value)
		owner.queue_free()
