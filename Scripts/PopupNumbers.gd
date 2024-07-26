extends Node

func get_direction():
	return Vector2(randf_range(-1,1), -randf()) * 16

func display_number(value: int, position: Vector2, is_damage: bool = true):
	var number = Label.new()
	number.global_position = position
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF" # white
	if is_damage == true:
		color = "FF0000"
		number.text = str(-value)
	else:
		color = "00FF00"
		number.text = str(value)
	
	number.label_settings.font_color = color
	number.label_settings.font_size = 20
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 15
	
	call_deferred("add_child", number)

	await number.resized
	number.pivot_offset = Vector2(number.size/2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(number, "position", number.global_position + get_direction(), 1).set_ease(Tween.EASE_OUT)
	tween.tween_property(number, "scale", Vector2.ZERO, 0.1).set_ease(Tween.EASE_OUT).set_delay(1)
	
	await tween.finished
	number.queue_free()
