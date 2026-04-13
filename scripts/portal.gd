extends Node2D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.has_method("player"):
			get_tree().change_scene_to_file("res://thechef.tscn")
