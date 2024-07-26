extends CharacterBody2D

#if we are not moving we turn to food
@onready var food_scene = preload("res://Scenes/Food.tscn")
var pos: Vector2
var count: int

func _ready() -> void:
	
	count += 1

func _on_timer_timeout():
	var last_pos = global_position
	await get_tree().create_timer(1).timeout	
	var current_pos = global_position
	
	if last_pos == current_pos:
		if count == 5:
			_turn_to_food()
		count += 1
	#hitflash

func _turn_to_food():
	var food = food_scene.instantiate()
	food.global_position = global_position
	add_sibling(food)
	self.queue_free()
