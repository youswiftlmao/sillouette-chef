extends ProgressBar


@onready var damagebar: ProgressBar = $damagebar
@onready var timer: Timer = $Timer
var health := 100 : set = _set_health
var prevhealth := 100
var damage_speed := 10
var waiting := false


func _set_health(new_health):
	if max_value == 0:
		max_value = 100

	prevhealth = health
	health = clamp(new_health, 0, max_value)
	value = health

	if health <= 0:
		queue_free()

	if health < prevhealth:
		# optional delay before damage bar starts moving
		await get_tree().create_timer(0.3).timeout
func init_health(_health):
	health = _health
	max_value = health
	value = health
	damagebar.max_value = health
	damagebar.value = health 


func _on_timer_timeout() -> void:
	damagebar.value = health
func _process(delta):
	if damagebar.value > health:
		damagebar.value = move_toward(damagebar.value, health, damage_speed * delta)
