class_name PathNode

var room_name: String
var marker_name: String

@warning_ignore("SHADOWED_VARIABLE")
func _init(room_name: String, marker_name: Variant = null) -> void:
	self.room_name = room_name
	if marker_name is String:
		self.marker_name = marker_name as String
