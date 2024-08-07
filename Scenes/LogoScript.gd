extends Node2D
@export var controls: Resource = null

	
var charge: float = 0
var pressed: bool = false
var pressed2: bool = false

func _process(delta) -> void:
	if Input.is_action_just_pressed(controls.dash) == true and pressed == false:
		if charge < 1: $LogoAnimation.play("Hold")
		pressed = true
		
	if Input.is_action_pressed(controls.dash) == true:
		if charge < 1: charge += .02
		#if charge >= 1: $Logo.material.set_shader_parameter("enabled", true)
		
	if Input.is_action_just_released(controls.dash):
		if charge >= 1 and pressed2 == false:
			pressed2 = true
			$LogoAnimation.play("Transition")
			$"../Camera2D"._camera_shake(2)
			await get_tree().create_timer(.5).timeout
			$"../Camera2D"._camera_shake(50)
			await get_tree().create_timer(1).timeout
			self.queue_free()
		else: charge = 0
