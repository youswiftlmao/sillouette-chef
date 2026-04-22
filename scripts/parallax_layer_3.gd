extends ParallaxLayer

@export var speed: float = 75.0

func _process(delta):
	motion_offset.x -= speed * delta
