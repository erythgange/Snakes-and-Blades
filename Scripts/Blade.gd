extends Node2D

var left: bool = true

func _process(delta):
	if Input.is_action_just_released("Dash"):
		if left == true:
			$BladeAnimation.play("Swing")
			left = false
		else: 
			$BladeAnimation.play("Swing_mirror")
			left = true
