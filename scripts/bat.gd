extends CharacterBody2D

var speed = 30
var playerchase = false
var player = null

var health = 100
var playerinattackzone = false
var cantakedamage = true
func  _physics_process(delta: float) -> void:
	deal_with_damage()
	
	if health <= 0 :
		cantakedamage = false
		playerinattackzone = false
		$bat.play("die")
		await $bat.animation_finished
		self.queue_free()
	if playerchase:
		position +=(player.position - position)/speed 
		
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
	if health <= 0:
		return
	if playerinattackzone and Gobal.chef_current_attack == true and health > 0:
		if cantakedamage == true:
			health -= 51
			

			$hit.play()
			$"takedamage cd".start()
			cantakedamage = false


func _on_takedamage_cd_timeout() -> void:
	if health > 0 :
		cantakedamage = true
