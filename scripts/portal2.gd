extends Node2D

var cantp = false





func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.has_method("player") and cantp:
			Transition.fade_to_scene("res://scenes/game.tscn")


func _on_thechef_cango_2_nextlvl() -> void:
	cantp = true
