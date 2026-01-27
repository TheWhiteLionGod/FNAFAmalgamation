"""
This Script Will Control Toy Freddy Behavior
"""
extends Animatronic

@export_range(0, 20) var AI_LEVEL: int = 20
var hasMoved: bool = false

@onready var killStage: int = kill()

func _init():
	super(3)

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

			# Move
			print("move")
			moveToStageMarker()

			# Progressing Stage
			@warning_ignore("int_as_enum_without_cast")
			currentStage += 1

		killStage:
			# TODO: Write Blackout Code
			pass
		
		_:
			print(
				"Invalid Stage Reached for Toy Freddy Animatronic: " + 
				str(currentStage)
				)
