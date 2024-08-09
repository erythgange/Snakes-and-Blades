extends Label

@export var time_left: int


func round_start():
	
	for x in time_left: 
		await get_tree().create_timer(.001).timeout
		text = str(x)
	set_physics_process(true)
	visible = true
	$RoundCountdownTimer.start()

func _ready(): 
	set_physics_process(false)
	$RoundCountdownTimer.wait_time = time_left
	
func _physics_process(delta): 
	update_label_text()
	
func update_label_text(): 
	text = str(ceil($RoundCountdownTimer.time_left))


func _on_round_countdown_timer_timeout():
	time_left -= 1
	self.text = str(time_left)
	if time_left < 1: 
		if $SnakeHead.Health > $SnakeHead2.Health: $"../..".p1_win = true
		else: $"../..".p2_win = true
		$"../.."._end_round()
