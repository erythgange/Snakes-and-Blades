extends Node2D

var snake: int
var snake1: bool = false
var snake2: bool = false
var round_start: bool = false


func _ready():
	Engine.max_fps = 60
	Engine.time_scale = 1
	set_physics_process(true)
	$Camera2D/RoundCountdown.visible = true
	$AnimationPlayer.play("start")
	$Camera2D/Top.visible = true
	$Camera2D/Bottom.visible = true

func _round_start():
	if round_start == false:
		$Camera2D/RoundCountdown.round_start()
		$AnimationPlayer.play("normal")
	round_start = true
	

var greenlight: bool = false
func _get_snake_signal(index):
	if index == 1: snake1 = true
	if index == 2: snake2 = true
	#if snake1 == true and snake2 == true:
		
		
var p1_win: bool = false
var p2_win: bool = false
var game_over_done: bool = false
func _game_over(snake_lost: int):
	if game_over_done == false:
		if snake_lost == 1: p2_win = true
		if snake_lost == 2: p1_win = true
		await get_tree().create_timer(.7, true, true, true).timeout
		game_over_done = true
		_end_round()


var snake_winner
func _end_round():
	$Camera2D/RoundCountdown.visible = false
	$AnimationPlayer.play_backwards("normal")
	if (p1_win == true and p2_win == true) or (p1_win == false and p2_win == false):
		$Camera2D/Winner.text = "TIE!"
	elif p2_win == true:
		$Camera2D/Winner.text = "P2 WINS!"
		snake_winner = $SnakeHead2
		set_physics_process(true)
	elif p1_win == true:
		$Camera2D/Winner.text = "P1 WINS!"
		snake_winner = $SnakeHead
		set_physics_process(true)
	
	Engine.time_scale = 1
	$Camera2D/Winner.visible = true

	await get_tree().create_timer(3, true, true, true).timeout
	$AnimationPlayer.play_backwards("close")
	await get_tree().create_timer(2, true, true, true).timeout
	_ready()
	
	get_tree().change_scene_to_file("res://Scenes/Arena.tscn")


func _physics_process(delta):
	# false start
	if round_start == false:
		#print("before round start")
		if snake1 == true:
			$Camera2D/FalseStart.visible = true
			$SnakeHead.bonus_speed = -30.0
			$Camera2D/FalseStart.text = "P1 False Start!"
			await _round_start()
		elif snake2 == true:
			$Camera2D/FalseStart.visible = true
			$SnakeHead.name = "SnakeHead2"
			$SnakeHead2.bonus_speed = -30.0
			$Camera2D/FalseStart.text = "P2 False Start!"
			await _round_start()
	else: 
		await get_tree().create_timer(2, true, false, true).timeout
		#print("after round start")
		$Camera2D/FalseStart.visible = false
		if p1_win == true and p2_win == true: pass
		elif p1_win == true: 
			$Camera2D.global_position = $SnakeHead.global_position
		elif p2_win == true: 
			$Camera2D.global_position = $SnakeHead2.global_position
		
		
			
	#	set_physics_process(false)
		
		

func _on_animation_player_animation_finished(start):
	_round_start()

func _on_round_countdown_timer_timeout():
	round_start == true
