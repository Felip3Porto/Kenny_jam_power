extends CharacterBody2D
@export var thrust_power: float = 1200.0
@export var rotation_speed: float = 3.0
@export var drag: float = 0.98

func _physics_process(delta: float) -> void:
	# Rotation with WASD
	var rotation_input = 0.0
	if Input.is_action_pressed("move_left"):
		rotation_input -= 1.0
	if Input.is_action_pressed("move_right"):
		rotation_input += 1.0
	
	# Apply rotation
	rotation += rotation_input * rotation_speed * delta
	
	# Thrust with w, reverse with S
	if Input.is_action_pressed("move_up"):
		var thrust = Vector2.UP.rotated(rotation) * thrust_power
		velocity += thrust * delta
	elif Input.is_action_pressed("move_down"):
		var thrust = Vector2.UP.rotated(rotation) * -thrust_power * 0.5
		velocity += thrust * delta
	
	# Apply drag for floaty feel
	velocity *= drag
	
	move_and_slide()
