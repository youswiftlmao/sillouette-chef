extends TextureButton


var clicked = 0 
signal ITEM1

func _physics_process(delta: float) -> void:
	if clicked >= 3:
		emit_signal("ITEM1")
		$"../blip2".play()
		queue_free()
	if clicked == 2 :
		position = Vector2(1996, -238)
		$".".texture_normal = load("res://assets/wheatdrop.png")
		custom_minimum_size = Vector2(16, 16)
		position = Vector2(1996, -238)
func _on_pressed() -> void:
	clicked += 1
	$"../blip12".play()
	$AnimationPlayer.play("click")
