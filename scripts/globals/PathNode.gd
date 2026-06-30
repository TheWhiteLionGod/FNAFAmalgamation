class_name PathNode

var camera: String
var marker: String

@warning_ignore("SHADOWED_VARIABLE")
func _init(camera: String, marker: Variant = null) -> void:
	self.camera = camera
	if marker is String:
		self.marker = marker as String
