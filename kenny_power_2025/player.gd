extends CharacterBody2D

signal health_depleted 
signal power_depleted

@export var thrust_power: float = 1200.0
@export var rotation_speed: float = 3.0
@export var drag: float = 0.98

#health bars
var hull_health = 100.0
var power = 100.0
var power_loss = .03 # can improve or worsen efficiency


#letting the laser inherit position
@export var laser_scene: PackedScene
var can_shoot: bool = true

### we can put last minute changes to power and health levels here? 

	
func _physics_process(delta: float) -> void:
	# Rotation with WASD
	var rotation_input = 0.0
	if Input.is_action_pressed("move_left"):
		rotation_input -= 1.0
		power -= power_loss
		%Power.value = power 
	if Input.is_action_pressed("move_right"):
		rotation_input += 1.0
		power -= power_loss
		%Power.value = power 
	
	if power <= 0:
		power_depleted.emit()
	# Apply rotation
	rotation += rotation_input * rotation_speed * delta
	
	# Thrust with w, reverse with S
	if Input.is_action_pressed("move_up"):
		var thrust = Vector2.UP.rotated(rotation) * thrust_power
		velocity += thrust * delta
		power -= power_loss
		%Power.value = power 
	elif Input.is_action_pressed("move_down"):
		var thrust = Vector2.UP.rotated(rotation) * -thrust_power * 0.5
		velocity += thrust * delta
		power -= power_loss
		%Power.value = power 
	
	# Apply drag for floaty feel
	velocity *= drag
	
	move_and_slide()
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot_laser()
	
	const DAMAGE_RATE = 5.0
	#% is only usuable after we envoke a unique name
	var overlaping_mobs = %HurtBox.get_overlapping_bodies()
	print("Overlapping areas found: ", overlaping_mobs.size())  # Debug line
	#print("Current hull health: ", hull_health)  # Debug line
	#check for damage
	if overlaping_mobs.size() > 1: 
		#works but now my own player colision box is counted wihtin fix later?
		#print("Taking damage from ", overlaping_mobs.size(), " mobs")  # Debug line
		hull_health -= DAMAGE_RATE * overlaping_mobs.size() * delta
		%Hull_Health.value = hull_health
		#print("New health: ", hull_health)  # Debug line
		#%Hull_Health.max_value = new number is how we can also mod player health for upgrades
		if hull_health <= 0: 
			health_depleted.emit()
			#allows us to pick up a signal in the node menu from a variable we made 
			#placeholder breakpoint 

func shoot_laser():
	if laser_scene:
		print("Trying to shoot laser...")
		var laser = laser_scene.instantiate()
		power -= power_loss
		%Power.value = power 
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
