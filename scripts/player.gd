extends CharacterBody2D


const SPEED = 175.0
const JUMP_VELOCITY = -270.0
 
@onready var chef: AnimatedSprite2D = $chef


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	#flips sprite 
	if direction > 0:
		chef.flip_h = false
	elif direction < 0 :
		chef.flip_h = true
		 
	#animations
	if is_on_floor():
		if direction == 0:
			chef.play("idle")
		else:
			chef.play("run")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$jump.play()
		chef.play("jump")

	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
