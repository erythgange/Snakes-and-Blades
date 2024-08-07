extends Node2D

var snake: int
var snake1: bool = false
var snake2: bool = false

func _ready():
	Engine.max_fps = 60

func _get_snake_signal(index):
	if index == 1: snake1 = true
	if index == 2: snake2 = true
	
	if snake1 == true and snake2 == true:
		print("starting countdown")
		$Countdown.start()
