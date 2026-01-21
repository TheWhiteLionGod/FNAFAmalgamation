"""
This Node will Handle the Puppet Animatronic
"""
extends Animatronic

@export var musicBox: StaticBody3D
@export_range(0, 20) var AI_LEVEL: int = 20

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
			# Will Try to Kill Every Frame
			if randi_range(0, 20) > AI_LEVEL:
				return; # Failed Movement

			jumpscare(get_tree().current_scene.get_node("Player"), 0.8, 1.7, Vector3(0.05, -1.55, -2.4))
			playerKilled()
			
			# await get_tree().create_timer($"AnimationPlayer".get_animation("jumpscare").length).timeout

		_:
			print(
				"Invalid Stage Reached for Puppet Animatronic: " + 
				Stage.keys()[currentStage]
				)
