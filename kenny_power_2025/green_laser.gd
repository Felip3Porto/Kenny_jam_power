extends Area2D

@export var laser_speed: float = 1000.0
var velocity: Vector2

func _ready():
	# Delete laser after 3 seconds
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	timer.start()

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_timeout():
	queue_free()

func setup_laser(spawn_position: Vector2, spawn_rotation: float, ship_velocity: Vector2):
	position = spawn_position
	rotation = spawn_rotation
	# Inherit ship velocity + add laser speed in facing direction
	velocity = ship_velocity + Vector2.UP.rotated(spawn_rotation) * laser_speed

#function from node signals menu
func _on_body_entered(body: Node2D) -> void:
	#queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
