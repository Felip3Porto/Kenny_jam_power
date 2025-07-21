extends CharacterBody2D
signal player_nearby(player)
signal player_left(player)

func _on_area_entered(body):
	if body.is_in_group("player"):
		player_nearby.emit(body)
