"""
This Node will Handle the Puppet Animatronic
"""
extends Animatronic

@export var musicBox: StaticBody3D

func _ready() -> void:
	GameState.musicBoxEmpty.connect(enterKillStage)
	super._ready()

func enterKillStage() -> void:
	currentStage = Stage.KILL

func handleStage() -> void:
	match currentStage:
		Stage.ZERO:
			pass

		Stage.KILL:
			print("Puppet Killed Player")

		_:
			print(
				"Invalid Stage Reached for Puppet Animatronic: " + 
				Stage.keys()[currentStage]
				)
