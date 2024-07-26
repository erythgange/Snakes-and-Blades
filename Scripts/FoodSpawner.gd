extends Node

@onready var food_scene := preload("res://Scenes/Food.tscn")
var food_count = get_child_count()

func _ready() -> void:
	_spawn_food()

func _spawn_food() -> void:
	var food = food_scene.instantiate()
	food.global_position = self.position
	add_sibling(food)
	

func _on_timer_timeout():
	_spawn_food()

#randf_range(-10,10), -randf()
