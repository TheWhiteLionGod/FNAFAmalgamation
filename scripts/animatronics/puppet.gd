"""
This Script Will Handle the Puppet Animatronic
"""
extends Animatronic

signal configReady
@export var musicBox: StaticBody3D
@export_range(0, 20) var AI_LEVEL: int = 20
@export var config: PuppetConfig:
	set(value):
		config = value
		configReady.emit()

@onready var killStage: int = getKillStage()

func _init():
	await configReady
	super(config.stages)

func _ready() -> void:
	GameState.musicBoxEmpty.connect(enterKillStage)

func enterKillStage() -> void:
	currentStage = killStage

func handleStage() -> void:
	match currentStage:
		0:
			visible = false

		killStage:
			visible = true
			
			# Will Try to Kill Every Frame
			if randi_range(0, 20) > AI_LEVEL:
				return; # Failed Movement

			GameState.playerActions["direction"] = GameState.Facing.MUSIC_BOX
			GameState.turn.emit()

			jumpscare(config.intensity, config.decayRate, config.jumpscarePosOffset)
			playerKilled()

		_:
			print(
				"Invalid Stage Reached for Puppet Animatronic: " + 
				str(currentStage)
				)
