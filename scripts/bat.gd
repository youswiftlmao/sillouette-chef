extends CharacterBody2D

var speed = 30
var playerchase = false
var player = null
var dead = false
var health = 100
var playerinattackzone = false
var cantakedamage = true

func _physics_process(delta: float) -> void:
	if dead:
		return

	deal_with_damage()
	bat_attack()

	if health <= 0:
		dead = true
		$"detection area".monitoring = false
		$CollisionShape2D.disabled = true
		$bathitbox.monitoring = false
		playerchase = false
		playerinattackzone = false
		cantakedamage = false

		velocity = Vector2.ZERO

		$bat.play("die")
		await $bat.animation_finished
		queue_free()
		return

	if playerchase:
		var dir = (player.position - position).normalized()
		velocity = dir * 100  # adjust speed here
		move_and_slide()
		
		if (player.position.x - position.x) < 0:
			$bat.flip_h = true
		else:
			$bat.flip_h = false
func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	playerchase = true
	
	

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	playerchase = false
func bat():
	pass


func _on_bathitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player") :
		playerinattackzone = true


func _on_bathitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player") :
		playerinattackzone = false
		
func deal_with_damage():
	if dead:
		return
	if playerinattackzone and Gobal.chef_current_attack and cantakedamage:
		if cantakedamage == true:
			health -= 51

			$hit.play()
			$"takedamage cd".start()
			cantakedamage = false


func _on_takedamage_cd_timeout() -> void:
	if health > 0 :
		cantakedamage = true
func bat_attack():
	if dead:
		return

	if playerinattackzone:
		if $bat.animation != "atack":
			$bat.play("atack")
	else :
		$bat.play("default")
