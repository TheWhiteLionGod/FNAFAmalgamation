"""
This Script Will Control Toy Freddy Behavior
"""
extends Animatronic

@export_range(0, 20) var AI_LEVEL: int = 20
var hasMoved: bool = false



@onready var killStage: int = getKillStage()

func _init():
	super(3)

func handleStage() -> void:
	match currentStage:
		0, 1:
			var curTime = GameState.globalTimer
			curTime = round(curTime * 10) / 10
			
			# NOT Movement Opportunity (10.0, 20.0, 30.0, etc)
			if int(curTime) % 2 != 0 || curTime - int(curTime) != 0:
				hasMoved = false # Resetting Boolean
				return

			if hasMoved:
				return
			
			# This is a Movement Opportunity
			hasMoved = true
			if randi_range(0, 20) > AI_LEVEL:
				return; # Failed Movement

			# Move
			print(currentStage)
			print("move")

			# Progressing Stage
			currentStage += 1

			moveToStageMarker()

		killStage:
			GameState.blackout.emit(5)

			
		
		_:
			print(
				"Invalid Stage Reached for Toy Freddy Animatronic: " + 
				str(currentStage)
				)
