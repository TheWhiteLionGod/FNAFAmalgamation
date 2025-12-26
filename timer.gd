extends MarginContainer

@onready var GUI: CanvasLayer = $".."
@onready var label: Label = $"./Time"
@onready var Events: Node3D = GUI.Events

func _process(_delta: float) -> void:
	var minutes: int = floor(Events.globalTimer / 60)
	var seconds: int = int(Events.globalTimer) % 60
	var milliseconds: int = int(round((Events.globalTimer - int(Events.globalTimer))*10)) % 10
	label.text = str(minutes) + ":" + \
				("0" if seconds < 10 else "") + \
				str(seconds) + \
				"." + str(milliseconds)
