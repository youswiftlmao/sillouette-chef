extends TextureButton





func _on_pressed() -> void:
	Transition.fade_to_scene("res://scenes/game.tscn")
