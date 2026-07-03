extends Animatronic
class_name Freddy

@export var config: FreddyConfig 
var path_pointer: int = 0

func move_to_start() -> void:
	move_to_path(config.path[0])

func tick() -> void:
	if not Movement.on_interval(config.interval):
		return

	if move_to_path(config.path[path_pointer + 1]):
		path_pointer += 1
		print("Successfully Moved to ", global_position)
	else:
		print("Failed to move..")
