"""
Modifies the Timer Label with the Time from Game State
"""
extends MarginContainer

@onready var label: Label = $"./Time"
var timer: float = 0.0

func updateText() -> void:
	var minutes: int = floor(timer / 60)
	var seconds: int = int(timer) % 60
	var milliseconds: int = int(round((timer - int(timer))*10)) % 10
	
	label.text = str(minutes) + ":" + \
				("0" if seconds < 10 else "") + \
				str(seconds) + \
				"." + str(milliseconds)

func _ready() -> void:
	timer = 0

func _process(delta: float) -> void:
	timer += delta
	GameState.globalTimer = timer
	updateText()
