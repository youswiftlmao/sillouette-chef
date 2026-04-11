extends CharacterBody2D


const SPEED = 175.0
const JUMP_VELOCITY = -270.0


@onready var chef: AnimatedSprite2D = $chef

var was_on_floor: bool = false

var gotitem1 = false
var gotitem2 = false
var gotitem3 = false
var gotitem4 = false


func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		# sfx for ump landing cuz idk where 2 put it
	if is_on_floor() and not was_on_floor:
		$land_thud.play()

	was_on_floor = is_on_floor()

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
			$Footstep.stop()
			$FootstepTimer.stop()
		else:
			chef.play("run")

			if $FootstepTimer.is_stopped():
				$Footstep.play()      # instant first step
				$FootstepTimer.start()

	else:
		$Footstep.stop()
		$FootstepTimer.stop()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		$jump.play()
		chef.play("jump")
		$Footstep.stop()
		$FootstepTimer.stop()
			
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_time_footstep_timer_timeout() -> void:
	$Footstep.play()
