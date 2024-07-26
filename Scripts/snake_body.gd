extends RigidBody2D
@onready var food_scene = preload("res://Scenes/Food.tscn")
@onready var hit_flash = $HitFlash
var pos: Vector2
var count: int

func _turn_to_food():
	var food = food_scene.instantiate()
	food.global_position = global_position
	add_sibling(food)
	self.queue_free()

func _detached():
	await get_tree().create_timer(10).timeout	
	hit_flash.play("hit_flash")
	await get_tree().create_timer(1.2).timeout	
	hit_flash.play("hit_flash")
	await get_tree().create_timer(.8).timeout	
	hit_flash.play("hit_flash")
	await get_tree().create_timer(.5).timeout	
	hit_flash.play("hit_flash")
	await get_tree().create_timer(.2).timeout
	_turn_to_food()
