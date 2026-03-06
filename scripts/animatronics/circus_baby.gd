"""
This Script Controls Circus Baby's Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int
@export var config: CircusBabyConfig:
	set(value):
		config = value
		configReady.emit()

@export var springtrap: Animatronic
@export var ballora: Animatronic

var movementOpportunity: MovementOpportunity
var lock: bool = false

func _init():
	await configReady
	super(config.stages)
	movementOpportunity = MovementOpportunity.new(config.movementInterval)

func _ready() -> void:
	super._ready()
	currentStage = (springtrap.currentStage + 1 
					if springtrap.currentStage + 1 != ballora.currentStage 
					else springtrap.currentStage - 1)
	
	currentStage = max(min(currentStage, 10), 4)
	moveToStageMarker()

func handleStage() -> void:
	match currentStage:
		4, 5, 6, 7, 8, 9, 10:
			if lock:
				return
			lock = true

			if GameState.playerState.inCameras and GameState.playerState.activeCamera == currentStage:
				await GameState.wait(2)
				lock = false

				if GameState.audioCam == currentStage:
					return

				if GameState.playerState.activeCamera == currentStage:
					currentStage = -1 # Killing Player
					return

				GameState.closeCamera.emit()

			# Failed Movement
			if !movementOpportunity.check(AI_LEVEL):
				lock = false
				return
			
			# Progressing Stage
			currentStage = (springtrap.currentStage + 1 
					if springtrap.currentStage + 1 != ballora.currentStage 
					else springtrap.currentStage - 1)
	
			currentStage = max(min(currentStage, 10), 4)
			moveToStageMarker()
			lock = false

		-1:
			jumpscare(config.intensity, config.decayRate, config.direction)
			playerKilled()

		_:
			print(
				"Invalid Stage Reached for Ballora Animatronic: " + 
				str(currentStage)
				)
