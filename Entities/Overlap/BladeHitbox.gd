extends Area2D

var speed = 1

func _on_area_entered(area):
	# can it _hurt?
	if area.owner.has_method("_hurt"):
		var value =  owner.speed/2  # get damage
		area.owner._hurt(value/2, false, speed) # apply damage
