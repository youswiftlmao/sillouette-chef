extends TextureButton

var clicked = 0 
signal ITEM3


func _on_pressed() -> void:
	clicked += 1

	$click1.play()

	position.y += 1
	await get_tree().create_timer(0.05).timeout
	position.y -= 1

	if clicked == 3:
		$click2.play()
		await $click2.finished
		emit_signal("ITEM3")
		queue_free()
