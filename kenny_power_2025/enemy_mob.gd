extends CharacterBody2D

#mobs basically need to know wherever the player is 
#the way godot works  is that it loads everyscript first 
#before the player scene can even be made hence we cannot 
#inherit anything from it right away so we must do a ready check
@onready var player = get_node("/root/Game/Player")

#can be modified for difficulty
var health = 3

#func _ready() -> void:
	#player = get_node("/root/Game/Player")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300.0 #probably needs to be faster 
	move_and_slide()
	
func take_damage():
	#health = health - 1
	health -= 1
	
	if health == 0:
		#we despawn the critter when it has no health
		queue_free()
	
