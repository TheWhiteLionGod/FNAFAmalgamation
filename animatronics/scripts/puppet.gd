"""
This Node will Handle the Puppet Animatronic
"""
extends Animatronic

@export var musicBox: StaticBody3D
@export_range(0, 20) var AI_LEVEL: int = 20

@onready var killStage: int = getKillStage()

func _init():
	super(2)

func _ready() -> void:
	GameState.musicBoxEmpty.connect(enterKillStage)

func enterKillStage() -> void:
	currentStage = killStage

func handleStage() -> void:
	match currentStage:
		0:
			visible = false
			pass

		killStage:
			visible = true
			
			# Will Try to Kill Every Frame
			if randi_range(0, 20) > AI_LEVEL:
				return; # Failed Movement

			jumpscare(0.8, 1.7, Vector3(0.05, -1.55, -2.4))
			playerKilled()

		_:
			print(
				"Invalid Stage Reached for Puppet Animatronic: " + 
				str(currentStage)
				)
