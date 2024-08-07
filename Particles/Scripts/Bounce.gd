extends Node2D

func _ready():
	$Smoke.emitting = true
	$Dust.emitting = true
	
func start(speed, is_sword_onleft, pos) -> void:
	global_position = pos
	$Smoke.initial_velocity_max = int(speed)/5
	$Smoke.amount = int(speed)/10
	$Dust.initial_velocity_max = int(speed)/2
	$Dust.amount = int(speed)/10



func _on_dust_finished():
	$".".queue_free()
