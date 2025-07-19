extends CharacterBody2D
signal health_depleted 

@export var thrust_power: float = 1200.0
@export var rotation_speed: float = 3.0
@export var drag: float = 0.98


var hull_health = 100.0

#letting the laser inherit position
@export var laser_scene: PackedScene
var can_shoot: bool = true
	
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
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot_laser()
	
	const DAMAGE_RATE = 5.0
	#% is only usuable after we envoke a unique name
	var overlaping_mobs = %Hurtbox.get_overlapping_bodies()
	#check for damage
	if overlaping_mobs.size() > 0: 
		hull_health -= DAMAGE_RATE * overlaping_mobs.size() * delta
		if hull_health <= 0: 
			health_depleted.emit()
			#allows us to pick up a signal in the node menu from a variable we made 

func shoot_laser():
	if laser_scene:
		print("Trying to shoot laser...")
		var laser = laser_scene.instantiate()
		print("Laser instantiated: ", laser)
		
		# Try different parent options
		var parent = get_parent()
		print("Parent is: ", parent)
		
		if parent:
			parent.add_child(laser)
			print("Added laser to parent")
			laser.setup_laser(global_position, rotation, velocity)
			print("Laser setup complete")
		else:
			print("No parent found!")
			
		can_shoot = false
		await get_tree().create_timer(0.2).timeout
		can_shoot = true
