extends Resource
class_name Health

var cur_health : int
@export var max_health: int = 10:
	set(value):
		max_health = value
		cur_health = value

signal current_health(value) # only useful for health change and not to indicate damage

# damage vs healing (signal very up health)
signal down_health
signal up_health

# % amount of health
signal low_health
signal no_cur_health

func decrease_health(value : int = 1) -> void:
	cur_health -= value
	current_health.emit(cur_health)
	if cur_health <= 0:
		no_cur_health.emit()

func increase_health(value : int = 1) -> void:
	cur_health += value
	current_health.emit(cur_health)
