extends Node2D

#States: 1 = Neutral, 2 = Charging(1/3), 3 = Charging(2/3), 4 = Charging(3/3), 5 = Parrying
var State = 1

func _process(delta):
	if Input.is_action_just_pressed("Dash") and State == 1:
		State = 2
		print("Charging")
	
	if Input.is_action_just_released("Dash") and State == 3:
		print("Dashed!")
		$CooldownTimer.start()

	print (State)

func _on_cooldown_timer_timeout():
	State = 1
	print ("Dash Available")
	
