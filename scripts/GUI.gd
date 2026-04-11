extends CanvasLayer



func _on_toggleinv_pressed() -> void:
	$inv2/AnimationPlayer.play("open")


func _on_inv_pressed() -> void:
	$inv2/AnimationPlayer.play("close")
