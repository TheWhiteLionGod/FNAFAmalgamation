extends Resource
class_name FreddyConfig

@export var interval: int
var path: Array[PathNode] = [
	PathNode.new("Cam1", "3"), 
	PathNode.new("Cam1", "2"), 
	PathNode.new("Cam1", "1"),
	PathNode.new("Office")
]
