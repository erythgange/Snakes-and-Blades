extends CharacterBody2D

# Base values
var health: int = 100
@onready var popup_number_position = $PopupNumbersOrigin
@onready var hit_flash = $HitFlash

func _physics_process(delta) -> void:
	if health < 0:
		self.queue_free()

func _hitstun(time) -> void:
	Engine.time_scale = 0
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1

func _hurt(damage: int, is_collision: bool):
	PopupNumbers.display_number(damage, popup_number_position.global_position, true)
	hit_flash.play("hit_flash")
	_hitstun(damage/100+.2)
	if is_collision == true and health < 1: health = 1 # cant die in collision
	else: health -= damage

func _ready():
	_hurt(1, false)
