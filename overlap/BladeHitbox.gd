extends Area2D

@onready var value =  $"../..".speed + 10

func _on_area_entered(area):
	if area.owner.has_method("_hurt"):
		print(value)
		area.owner._hurt(value, false)

	


func _on_timer_timeout():
	var value =  $"../..".speed + 10
	print(value)
