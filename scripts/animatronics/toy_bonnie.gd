"""
This Script Will Control Toy Bonnie Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int
@export var config: ToyBonnieConfig:
	set(value):
		config = value
		configReady.emit()

var hasMoved: bool = false
var doingBlackout: bool = false

@onready var killStage: int = getKillStage()

func _init():
	await configReady
	super(config.stages)

func _ready() -> void:
	super._ready()

func handleStage() -> void:
	match currentStage:
		0, 1, 2:
			var curTime = GameState.globalTimer
			curTime = round(curTime * 10) / 10
			
			# NOT Movement Opportunity
			if int(curTime) % config.movementInterval != 0 or curTime - int(curTime) != 0:
				hasMoved = false # Resetting Boolean
				return

			if hasMoved:
				return
			
			# This is a Movement Opportunity
			hasMoved = true
			print(AI_LEVEL)
			if randi_range(0, 20) >= AI_LEVEL:
				return; # Failed Movement

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
