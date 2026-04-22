extends ParallaxLayer

@export var speed: float = 25.0

func _process(delta):
	motion_offset.x -= speed * delta
