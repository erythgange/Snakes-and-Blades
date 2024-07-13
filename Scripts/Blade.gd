extends Node2D

var left: bool = true
var is_blade_on_cooldown: bool = false

# Sword switching from left to right, vice versa
func _process(delta):
	
	if Input.is_action_just_released("Dash") and is_blade_on_cooldown == false:
		
		#Cooldown so yo can't spam attack
		$BladeCooldown.start()
		is_blade_on_cooldown = true
		if left == true:
			
			$BladeAnimation.play("blade_neutral_attack")
			left = false
		else: 
			$BladeAnimation.play("blade_neutral_attack_mirror")
			left = true


func _on_blade_cooldown_timeout():
	is_blade_on_cooldown = false
