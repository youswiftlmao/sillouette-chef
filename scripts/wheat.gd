extends TextureButton

var clicked = 0 
signal ITEM1

func _on_pressed() -> void:
	clicked += 1

	$click1.play()

	position.y += 1
	await get_tree().create_timer(0.05).timeout
	position.y -= 1

	if clicked == 2:
		position = Vector2(1996, -238)
		texture_normal = load("res://assets/wheatdrop.png")
		custom_minimum_size = Vector2(16, 16)

	if clicked == 3:
		emit_signal("ITEM1")
		$click2.play()
		await $click2.finished
		queue_free()
