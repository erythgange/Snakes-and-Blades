extends Node2D

var left: bool = true

func _process(delta):
	if Input.is_action_just_released("Dash"):
		if left == true:
			$Sprite2D.flip_h = true
			$BladeAnimation.play("Swing")
			
			left = false
		else: 
			$Sprite2D.flip_h = false
			$BladeAnimation.play("Swing_mirror")
			
			left = true
			
