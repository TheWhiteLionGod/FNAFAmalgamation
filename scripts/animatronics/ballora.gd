"""
This Script Controls Ballora's Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int
@export var config: BalloraConfig:
	set(value):
		config = value
		configReady.emit()
@export var springtrap: Animatronic

var movementOpportunity: MovementOpportunity
var lock: bool = false

func _init():
	await configReady
	super(config.stages)
	movementOpportunity = MovementOpportunity.new(config.movementInterval)

func _ready() -> void:
	super._ready()
	
	currentStage = springtrap.currentStage + [-1, 1].pick_random()
	if currentStage > 10:
		currentStage = springtrap.currentStage - 1
	elif currentStage < 0:
		currentStage = springtrap.currentStage + 1

	moveToStageMarker()

func handleStage() -> void:
	match currentStage:
		0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10:
			if lock:
				return
			lock = true

			if GameState.playerState.inCameras and GameState.playerState.activeCamera == currentStage:
				await GameState.wait(2)

				if GameState.audioCam == currentStage:
					lock = false
					return
				currentStage = -1 # Killing Player

			# Failed Movement
			if !movementOpportunity.check(AI_LEVEL):
				lock = false
				return
			
			# Progressing Stage
			currentStage = springtrap.currentStage + [-1, 1].pick_random()
			if currentStage > 10:
				currentStage = springtrap.currentStage - 1
			elif currentStage < 0:
				currentStage = springtrap.currentStage + 1
			
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
