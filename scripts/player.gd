extends CharacterBody2D


const SPEED = 175.0
const JUMP_VELOCITY = -270.0
#combat related vars
var health = 100

var bat_inattackrange = false
var bat_atckcooldown = true
var playeralive = true
var attackip = false


@onready var chef: AnimatedSprite2D = $chef
@onready var healthbar: ProgressBar = $CanvasLayer/healthbar


var was_on_floor: bool = false

var gotitem1 = false
var gotitem2 = false
var gotitem3 = false
var gotitem4 = false

func _ready() -> void:
	updhp()
	randomize()

func _physics_process(delta: float) -> void:
	
	enemyattack()
	updhp()
	attack()
	if health <= 0 and playeralive:
		playeralive = false
		health = 0
		set_physics_process(false)
		Transition.reset_scene()
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
		if attackip:
			pass
		elif direction == 0:
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
	#here under is for items recieved:
	if gotitem2 == true:
		$CanvasLayer/inv2/Done2.visible = true
	if gotitem1:
		$CanvasLayer/inv2/Done.visible = true
	if gotitem3 == true :
		$CanvasLayer/inv2/Done3.visible = true
func _on_time_footstep_timer_timeout() -> void:
	$Footstep.play()


func _on_salt_item_2() -> void:
	gotitem2 = true


func _on_wheat_item_1() -> void:
	gotitem1 = true
	


func _on_cow_item_3() -> void:
	gotitem3 = true
func player():
	pass
	
func updhp():
	healthbar.health = health


func _on_hurt_area_entered(area: Area2D) -> void:
	if area.has_method("hploss"):
		health -= 10
		healthbar.health = health
		print(health)


func _on_players_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("bat"):
		bat_inattackrange = true


func _on_players_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("bat"):
		bat_inattackrange = false
func enemyattack():
	if bat_inattackrange and bat_atckcooldown == true :
		health -= 7
		bat_atckcooldown = false
		$ATTACKCD.start()
		print("chef took damage", health)


func _on_attackcd_timeout() -> void:
	bat_atckcooldown = true
	
func attack():
	if Input.is_action_just_pressed("attack") and not attackip :
		Gobal.chef_current_attack = true
		attackip = true
		
		var attack_num = randi() % 4 + 1  # gives 1–4
		$chef.play("attack" + str(attack_num))
		$deal_atc_damage.start()

func _on_deal_atc_damage_timeout() -> void:
	$deal_atc_damage.stop()
	Gobal.chef_current_attack = false
	attackip = false
