"""
This Script Will Control Toy Freddy Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int = 20
@export var config: ToyFreddyConfig:
	set(value):
		config = value
		configReady.emit()

var hasMoved: bool = false

@onready var killStage: int = getKillStage()

var blackout: bool = false

func _init():
	await configReady
	super(config.stages)

func _ready() -> void:
	super._ready()
	GameState.blackoutEnd.connect(checkForKill)

func handleStage() -> void:
	match currentStage:
		0, 1:
			var curTime = GameState.globalTimer
			curTime = round(curTime * 10) / 10
			
			# NOT Movement Opportunity
			if int(curTime) % config.movementInterval != 0 || curTime - int(curTime) != 0:
				hasMoved = false # Resetting Boolean
				return

			if hasMoved:
				return
			
			# This is a Movement Opportunity
			hasMoved = true
			if randi_range(0, 20) > AI_LEVEL:
				return; # Failed Movement

			# Progressing Stage
			if GameState.playerState.inBlackout && currentStage + 1 == killStage:
				return; # Failing Movement If Blackout is Occuring

			currentStage += 1
			moveToStageMarker()

		killStage:
			if !blackout:
				blackout = true
				GameState.blackoutStart.emit(config.blackoutLength)

		_:
			print(
				"Invalid Stage Reached for Toy Freddy Animatronic: " + 
				str(currentStage)
				)

func checkForKill() -> void:
	if currentStage != killStage:
		return

	blackout = false

	if GameState.playerState.maskOn && GameState.playerState.facing == GameState.Facing.OFFICE:
		currentStage = 0
		moveToStageMarker()
		return

	jumpscare(config.intensity, config.decayRate, config.jumpscarePosOffset, GameState.Facing.OFFICE)
	playerKilled()
