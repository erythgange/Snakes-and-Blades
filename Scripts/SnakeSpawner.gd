extends Node2D

# controls
@export var controls: Resource = null

# base values
@export var spawn_bonus_speed: int = 550
@export var spawn_health: int = 20
var spawn_max_speed: float = spawn_health * 2
var spawn_speed: float = spawn_max_speed

const P1_CONTROLS = preload("res://Entities/Player/Controls/P1_Controls.tres")
const P2_CONTROLS = preload("res://Entities/Player/Controls/P2_Controls.tres")
const SNAKE_HEAD = preload("res://Entities/Player/snake_head.tscn")
var charge: float = 0
var index: int


func _ready():
	index = int((str(self).substr(13)).left(1))
	if index == 1: controls = P1_CONTROLS
	elif index == 2: controls = P2_CONTROLS
	#elif index == 3: controls = P3_CONTROLS
	#elif index == 4: controls = P4_CONTROLS

func _process(delta) -> void:
	if Input.is_action_just_pressed(controls.dash) == true: _hit_flash()
	if Input.is_action_pressed(controls.dash) == true:
		if charge < 1: charge += .02
		else: 
			$HoldCharge.material.set_shader_parameter("enabled", true)
			$Shine.emitting = true
	if Input.is_action_just_released(controls.dash):
		if charge >= 1: 
			spawn(index)
		charge = 0

func spawn(index) -> void:	
	var snake = SNAKE_HEAD.instantiate()
	snake.controls = controls
	
	var spawn_position = global_position
	snake.global_position = spawn_position
	$".."._get_snake_signal(index)
	
	snake.bonus_speed = spawn_bonus_speed
	snake.health = spawn_health
	snake.max_speed = spawn_max_speed
	snake.speed = spawn_speed
	add_sibling(snake)
	
	snake.dash_particles.emitting = true
	snake.turn_amplifier = 0
	snake.can_attack = false
	await get_tree().create_timer(1.4).timeout
	snake.turn_amplifier = 1
	snake.can_attack = true
	snake.set_collision_mask_value(1, true)
	
	
	self.queue_free()

func _hit_flash() -> void:
	$HoldCharge.material.set_shader_parameter("enabled", true)
	$Shine.emitting = true
	await get_tree().create_timer(.2).timeout
	$HoldCharge.material.set_shader_parameter("enabled", false)
	$Shine.emitting = false
	
