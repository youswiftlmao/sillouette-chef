extends ParallaxLayer

@export var speed: float = 50.0

func _process(delta):
	motion_offset.x -= speed * delta
