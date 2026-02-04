"""
This Script Will Control Toy Freddy Behavior
"""
extends Animatronic

@export_range(0, 20) var AI_LEVEL: int = 20
var hasMoved: bool = false

@onready var killStage: int = getKillStage()

var blackout: bool = false

func _init():
	super(3)

func _ready() -> void:
	super._ready()
	GameState.blackoutEnd.connect(checkForKill)

func handleStage() -> void:
	match currentStage:
		0, 1:
			var curTime = GameState.globalTimer
			curTime = round(curTime * 10) / 10
			
			# NOT Movement Opportunity (10.0, 20.0, 30.0, etc)
			if int(curTime) % 1 != 0 || curTime - int(curTime) != 0:
				hasMoved = false # Resetting Boolean
				return

			if hasMoved:
				return
			
			# This is a Movement Opportunity
			hasMoved = true
			if randi_range(0, 20) > AI_LEVEL:
				return; # Failed Movement

			# Progressing Stage
			currentStage += 1
			moveToStageMarker()

		killStage:
			if !blackout:
				blackout = true
				GameState.playerActions["in_blackout"] = true
				GameState.blackoutStart.emit(1)

		_:
			print(
				"Invalid Stage Reached for Toy Freddy Animatronic: " + 
				str(currentStage)
				)

func checkForKill() -> void:
	blackout = false

	if GameState.playerActions["mask"] && GameState.playerActions["direction"] == GameState.Facing.OFFICE:
		currentStage = 0
		moveToStageMarker()
		return

	jumpscare(0.8, 1.7, Vector3(0, -1.25, -0.9), GameState.Facing.OFFICE)
	playerKilled()
