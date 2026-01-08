"""
This Script Will Control Toy Freddy Behavior
"""
extends Animatronic

@export_range(0, 20) var AI_LEVEL: int = 20
var hasMoved: bool = true

func handleStage() -> void:
	match currentStage:
		Stage.ZERO, Stage.ONE:
			var curTime = GameState.globalTimer
			curTime = round(curTime * 10) / 10

			# NOT Movement Opportunity (10.0, 20.0, 30.0, etc)
			if int(curTime) % 10 != 0 || curTime - int(curTime) != 0:
				hasMoved = false # Resetting Boolean
				return

			if hasMoved:
				return
			
			# This is a Movement Opportunity
			hasMoved = true
			if randi_range(0, 20) > AI_LEVEL:
				return; # Failed Movement

			# Progressing Stage
			@warning_ignore("int_as_enum_without_cast")
			currentStage += 1

			print(Stage.keys()[currentStage])

		Stage.KILL:
			# TODO: Write Blackout Code
			pass
		
		_:
			print(
				"Invalid Stage Reached for Toy Freddy Animatronic: " + 
				Stage.keys()[currentStage]
				)