extends Node

@onready var food_scene := preload("res://Scenes/Food.tscn")

func _spawn_food() -> void:
	var food = food_scene.instantiate()
	food.global_position = self.position
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(food, "rotation", food.rotation+randf_range(-1,1)*100, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(food, "position", food.global_position + Vector2(randf_range(-1,1)*10,randf_range(-1,1))*10, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	add_sibling(food)

func _on_timer_timeout():
	_spawn_food()

#randf_range(-10,10), -randf()
