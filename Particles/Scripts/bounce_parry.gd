extends Node2D
	
func start(speed, is_sword_onleft, pos) -> void:
	$ParryLines.emitting = true
	$ParryCircle.emitting = true


func _on_parry_lines_finished():
	$".".queue_free()
