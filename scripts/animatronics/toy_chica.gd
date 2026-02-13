"""
This Script Will Control Toy Bonnie Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int
@export var config: ToyChicaConfig:
	set(value):
		config = value
		configReady.emit()

@onready var killStage: int = getKillStage()

var movementOpportunity: MovementOpportunity
var doingBlackout: bool = false

func _init():
	await configReady
	super(config.stages)
	movementOpportunity = MovementOpportunity.new(config.movementInterval)

func _ready() -> void:
	doingBlackout = false
	super._ready()

func handleStage() -> void:
	match currentStage:
		0, 1, 2:
			# Failed Movement
			if !movementOpportunity.check(AI_LEVEL):
				return

			# Progressing Stage
			currentStage += 1
			moveToStageMarker()

		killStage:
			if doingBlackout:
				return
			doingBlackout = true

			GameState.blackoutStart.emit(config.blackoutLength)
			await GameState.blackoutEnd
			checkForKill()

		_:
			print(
				"Invalid Stage Reached for Toy Bonnie Animatronic: " + 
				str(currentStage)
				)

func checkForKill() -> void:
	if GameState.playerState.maskOn and GameState.playerState.facing == config.direction:
		currentStage = 0
		doingBlackout = false
		moveToStageMarker()
		return

	jumpscare(config.intensity, config.decayRate, config.direction)
	playerKilled()