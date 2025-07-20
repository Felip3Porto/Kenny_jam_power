extends Node2D

#func _ready() -> void:
	#spawn_mobling()
	#spawn_mobling()
	#spawn_mobling()
	#spawn_mobling()

func spawn_mobling(): 
	var new_mob = preload("res://enemy_mob.tscn").instantiate()
	%Spawn_path.progress_ratio = randf() #we spawn it randomly on the path2d track
	new_mob.global_position = %Spawn_path.global_position
	add_child(new_mob) #adds this new mob to the game 


func _on_timer_timeout() -> void:
	spawn_mobling()
