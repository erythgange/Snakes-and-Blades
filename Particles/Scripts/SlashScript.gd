extends Node2D

func _ready():
	$AnimationPlayer.play("RESET")
	$MarkSprite.frame = 0
	
func start(speed, is_sword_onleft, pos) -> void:
	if speed < 150: $MarkSprite.frame = randi_range(1,4)
	
	if is_sword_onleft == true: 	
		$SlashSprite.flip_v = !$SlashSprite.flip_v
		$MarkSprite.flip_v = !$MarkSprite.flip_v
		$Sparks.rotation = deg_to_rad( randi_range(-100,-80) )
	else: $Sparks.rotation = deg_to_rad( randi_range(100,80) )
	

	
	$AnimationPlayer.play("Slash")
	
func _on_animation_player_animation_finished(AnimationPlayer):
	$".".queue_free()
	
