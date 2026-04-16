extends Node2D

signal lvl2now
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("lvl2now")
