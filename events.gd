extends Node3D

var globalTimer: float = 0.0

func _ready() -> void:
	globalTimer = 0


func _process(delta: float) -> void:
	globalTimer += delta