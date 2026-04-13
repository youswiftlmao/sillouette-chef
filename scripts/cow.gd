extends TextureButton

var clicked = 0 
signal ITEM3

func _physics_process(delta: float) -> void:
	if clicked >= 3:
		emit_signal("ITEM3")
		$"../blip2".play()
		queue_free()
 

func _on_pressed() -> void:
	clicked += 1
	$"../blip12".play()
	$AnimationPlayer.play("pick")
