extends Area2D

@export var value: int = 5

func _on_area_entered(area):
	if area.owner.has_method("_heal"):
		if area.owner.health < 100:
			area.owner._heal(value)
			owner.queue_free()
