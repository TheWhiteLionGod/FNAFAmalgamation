"""
This Script Will Control Foxy's Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int
@export var config: FoxyConfig:
	set(value):
		config = value
		configReady.emit()

@onready var killStage: int = getKillStage()
var movementOpportunity: MovementOpportunity
var lock: bool = false
var prevRushTime: float

func _init():
	await configReady
	super(config.stages)
	movementOpportunity = MovementOpportunity.new(config.movementInterval)

func _ready() -> void:
	prevRushTime = 0
	super._ready()

func handleStage() -> void:
	match currentStage:
		0:
			# Failed Movement
			if !movementOpportunity.checkLocal(AI_LEVEL, prevRushTime):
				return
			
			# Progressing Stage
			currentStage += 1
			moveToStageMarker()
		1:
			if lock:
				return

			lock = true
			await GameState.wait(2)
			prevRushTime = GameState.globalTimer
			lock = false

			if !GameState.playerState.leftDoorClosed:
				currentStage = killStage
			else:
				currentStage = 0
				moveToStageMarker()

		killStage:
			jumpscare(config.intensity, config.decayRate, config.direction)
			playerKilled()

		_:
			print(
				"Invalid Stage Reached for Foxy Animatronic: " + 
				str(currentStage)
				)