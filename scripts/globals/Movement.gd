class_name Movement

static var current_time: float = 0.0

static func reset_timer() -> void:
	current_time = 0.0

static func get_timer() -> float:
	return current_time

static func tick(delta: float) -> void:
	current_time += delta

static func on_interval(interval: float) -> bool:
	return fmod(roundf(current_time * 100) / 100, interval) == 0
