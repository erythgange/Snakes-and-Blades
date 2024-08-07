extends Node

@onready var food_scene := preload("res://Entities/Objects/Food.tscn")
@export var max_food = 2



func _spawn_food() -> void:
	var food = food_scene.instantiate()
	#food.position = self.global_position
	
	var tween = create_tween()
	tween.set_parallel()
	add_child(food)


func _on_timer_timeout():
	if get_child_count() < max_food:
		_spawn_food()

#randf_range(-10,10), -randf()
