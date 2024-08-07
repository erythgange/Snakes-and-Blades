extends Node2D

var snake: int
var snake1: bool = false
var snake2: bool = false

func _ready():
	Engine.max_fps = 60
	Engine.time_scale = 1

func _get_snake_signal(index):
	if index == 1: snake1 = true
	if index == 2: snake2 = true
	if snake1 == true and snake2 == true:
		$RoundCountdown/Timer.start()

func _game_over(snake_lost: int):
	print("Game Over!")
	print(snake_lost)
	if snake_lost == 1: $Winner.text = "P2 WINS!"
	if snake_lost == 2: $Winner.text = "P1 WINS!"
	$Winner.visible = true
	# if, 0 tie
	await get_tree().create_timer(2, true, true, true).timeout
	get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
