extends TextureButton




func _on_pressed() -> void:
	Transition.fade_to_scene("res://scenes/main_menu.tscn")
