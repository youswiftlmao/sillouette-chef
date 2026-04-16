extends CharacterBody2D

signal cango2nextlvl
signal lvl2rn
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
var lvl1 = false
var lvl2 = false
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
	
	if gotitem1 and gotitem2 and gotitem3 and gotitem4:
		emit_signal("cango2nextlvl")
	if health <= 0 and playeralive:
		playeralive = false
		health = 0
		bat_inattackrange = false
		bat_atckcooldown = true
		playeralive = true
		attackip = false
		set_physics_process(false)
		$chef.play("die")
		$dead.play()
		await get_tree().create_timer(1.0).timeout
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
		if not attackip :
			if direction == 0:
				chef.play("idle")
			else:
				chef.play("run")

		if is_on_floor() and direction != 0:
			if $FootstepTimer.is_stopped():
				$Footstep.play()
				$FootstepTimer.start()
		else:
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
	
	#lvl 2 changes
	
	if chef.animation == "hit" and not chef.is_playing():
		if is_on_floor():
			if Input.get_axis("left", "right") == 0:
				chef.play("idle")
			else:
				chef.play("run")
			

	#here under is for items recieved:
	if gotitem2 == true:
		$CanvasLayer/inv2/Done2.visible = true
	else: 
		$CanvasLayer/inv2/Done2.visible = false
	if gotitem1:
		$CanvasLayer/inv2/Done.visible = true
	else: 
		$CanvasLayer/inv2/Done.visible = false
	if gotitem3 == true :
		$CanvasLayer/inv2/Done3.visible = true
	else:
		$CanvasLayer/inv2/Done3.visible = false
	if gotitem4 == true : 
		$CanvasLayer/inv2/Done4.visible = true
	else:
		$CanvasLayer/inv2/Done4.visible = false
	if health > 100:
		health =  100
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
		health -= 15
		bat_atckcooldown = false
		flash_white()
		$damage.play()
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

func flash_white():
	chef.modulate = Color(15, 15, 15)
	await get_tree().create_timer(0.08).timeout
	chef.modulate = Color(1, 1, 1)


func _on_regen_timeout() -> void:
	health += 20


func _on_hiutboxarea_body_entered(body: Node2D) -> void:
	if body.name == "spikesmap":
		health = 0


func _on_soda_item_4() -> void:
	gotitem4 = true
	


func _on_lvl_2_lvl_2_now() -> void:
	lvl2 = true
	gotitem1 = false
	gotitem2 = false
	gotitem3 = false
	gotitem4 = false
	$CanvasLayer/inv2/todo.text = " eggs (chicken)"
	$"../pickups/wheat".texture_normal = load("res://assets/egg.png")
	$CanvasLayer/inv2/todo2.text = " sugar (in a sack)"
	$"../pickups/salt".texture_normal = load("res://assets/sugar.png")
	$CanvasLayer/inv2/todo3.text = " butter (cow) "
	$CanvasLayer/inv2/todo4.text = " chocolate (cacao tree)"
	$"../pickups/soda".texture_normal = load("res://assets/Tree.png")
	emit_signal("lvl2rn")
func _on_game_lvl_1() -> void:
	lvl1 = true
