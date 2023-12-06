extends Resource
class_name StatsShared

## properties
# health
var p_health_cur: int
@export var p_health_max: int = 10:
	set(value):
		p_health_max = value
		p_health_cur = value

# velocity
@export var p_velocity: float
@export var p_velocity_jump: float
@export var p_velocity_crouch: float

## signals
# health
signal s_health_cur(value)
signal s_health_cur_none

## methods
# health
func take_damage(value: int = 1) -> void:
	p_health_cur -= value
	s_health_cur.emit(p_health_cur)
	if p_health_cur <= 0:
		s_health_cur_none.emit()
