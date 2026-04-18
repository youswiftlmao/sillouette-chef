extends Node2D
signal lvl3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("lvl3")
