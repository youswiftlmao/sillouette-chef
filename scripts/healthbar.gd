extends ProgressBar


@onready var damagebar: ProgressBar = $damagebar
@onready var timer: Timer = $Timer
var prevhealth = float(health)
var health := 100 : set = _set_health

func _set_health(new_health):
	var prevhealth = float(health)

	if max_value == 0:
		max_value = 100

	health = clamp(new_health, 0, max_value)
	value = health

	if health <= 0:
		queue_free()

	if health < prevhealth:
		timer.start()
	else:
		damagebar.value = health

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damagebar.max_value = health
	damagebar.value = health 


func _on_timer_timeout() -> void:
	damagebar.value = health
