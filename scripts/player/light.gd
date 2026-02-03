"""
This Script Controls the Office Light
"""
extends SpotLight3D

@export var main: Node3D
@onready var environment: Environment = main.get_node("WorldEnvironment").environment
@onready var bufferEnergy: float = environment.background_energy_multiplier

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var duration: int = 0
var startTime: float = 0

func _ready() -> void:
	GameState.blackoutStart.connect(flickerLights)

func _process(_delta: float) -> void:
	if !GameState.playerActions["in_blackout"]:
		return

	if GameState.globalTimer - startTime >= duration:
		resetLights()
		return

	if rng.randi_range(1, 5) == 1:
		visible = !visible

func flickerLights(dur: int) -> void:
	duration = dur
	startTime = GameState.globalTimer
	
	visible = false
	environment.background_energy_multiplier = 0

func resetLights() -> void:
	GameState.playerActions["in_blackout"] = false
	visible = true
	environment.background_energy_multiplier = bufferEnergy
	GameState.blackoutEnd.emit()
