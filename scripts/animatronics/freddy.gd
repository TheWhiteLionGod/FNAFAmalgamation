extends Animatronic
class_name Freddy

var interval: int = 10
var path: Array[PathNode] = [
	PathNode.new("Cam1", "3"), 
	PathNode.new("Cam1", "2"), 
	PathNode.new("Cam1", "1"),
	PathNode.new("Office")
]
var path_pointer: int = 0

func tick() -> void:
	if not Movement.on_interval(interval):
		return
	
	if move_to_path(path[path_pointer + 1]):
		path_pointer += 1
