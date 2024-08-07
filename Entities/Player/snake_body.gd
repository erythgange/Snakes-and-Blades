extends RigidBody2D

@onready var food_scene = preload("res://Entities/Objects/Food.tscn")
@onready var snake_body_sprite = $SnakeBodySprite
var pos: Vector2

func _ready():
	pass

func _turn_to_food():
	var food = food_scene.instantiate()
	food.global_position = global_position
	add_sibling(food)
	self.queue_free()

# export
func _hit_flash() -> void: 
	snake_body_sprite.material.set_shader_parameter("enabled", true)
	await get_tree().create_timer(.2).timeout
	snake_body_sprite.material.set_shader_parameter("enabled", false)


func _set_collision(snake_layer, blade_layer) -> void: 
	set_collision_layer_value(snake_layer, true)
	$Hurtbox.set_collision_layer_value(snake_layer, true)
	$Hurtbox.set_collision_mask_value(blade_layer, false)



signal cut(body_part_number)
var body_part_number: int # has value when instantiated
var invulnerable: bool = false
func _hurt(damage: int, is_collision: bool, speed) -> void:
		print("snake body hit by blade!")
		print("body_part_number: %d" %body_part_number)
		emit_signal("cut",body_part_number)
		


func _detached(speed):
	_hit_flash()
	set_collision_layer_value(3, false)
	set_collision_mask_value(2, true)	
	set_collision_layer_value(5, true)
	
	
	
	await get_tree().create_timer(.2).timeout
	_hit_flash()
	await get_tree().create_timer(1).timeout	
	_hit_flash()
	await get_tree().create_timer(.5).timeout	
	_hit_flash()
	await get_tree().create_timer(.3).timeout	
	_hit_flash()
	await get_tree().create_timer(.2).timeout
	_turn_to_food()
