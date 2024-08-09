extends Node
@onready var number = $Label



func display_numbers(value: int, is_damage: bool = true, is_parry: bool = false):

	
	number.text = str(value)
	for x in value/20:
		if value < 100:
			number.text += "!"
			self.scale += Vector2(.2,.2)
			$AnimationPlayer.speed_scale += -.1
	
	
	if is_parry == true: 
		$AnimationPlayer.play("Parry")
		number.text = "Parry!"
	elif value == 0: 
		number.text = "Invulnerable"
		$AnimationPlayer.play("Neutral")
		
	elif is_damage == true: $AnimationPlayer.play("Damage")
	else: $AnimationPlayer.play("Heal")


	await $AnimationPlayer.animation_finished
	self.queue_free()
