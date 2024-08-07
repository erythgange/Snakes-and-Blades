extends Label

var time_left: int = int(text)


func _on_timer_timeout():
	if time_left > 0:
		time_left -= 1
		self.text = str(time_left)
	
	if time_left <= 0: 
		if $SnakeBody1.health > $SnakeBody2.health:
			$".."._game_over(2) #
		else: $".."._game_over(1) #
