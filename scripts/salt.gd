extends TextureButton

var clicked = 0 
signal ITEM2

func _physics_process(delta: float) -> void:
	if clicked >= 3:
		emit_signal("ITEM2")
		queue_free()


func _on_pressed() -> void:
	clicked += 1
	$AnimationPlayer.play("pick")
