extends Label

@export var time_left: int = 30


func round_start():
	for x in time_left: 
		await get_tree().create_timer(.001).timeout
		text = str(x)
	set_physics_process(true)
	visible = true
	$RoundCountdownTimer.start()

func _ready(): 
	set_physics_process(false)
	
func _physics_process(delta): 
	update_label_text()
	
func update_label_text(): 
	text = str(ceil($RoundCountdownTimer.time_left))


func _on_round_countdown_timer_timeout():
	if time_left > 0:
		time_left -= 1
		self.text = str(time_left)
	
	if time_left <= 0: 
		if $SnakeBody1.health > $SnakeBody2.health:
			$".."._game_over(2) #
		else: $".."._game_over(1) #

