"""
This Script Will Control Mangle's Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int
@export var config: MangleConfig:
	set(value):
		config = value
		configReady.emit()

@onready var killStage: int = getKillStage()
var movementOpportunity: MovementOpportunity
var lock: bool = false

func _init():
	await configReady
	super(config.stages)
	movementOpportunity = MovementOpportunity.new(config.movementInterval)

func _ready() -> void:
	super._ready()

func handleStage() -> void:
	match currentStage:
		0, 1:
			# Failed Movement
			if !movementOpportunity.check(AI_LEVEL):
				return

			# Progressing Stage
			currentStage += 1
			moveToStageMarker()

		2:
			if lock:
				return
			lock = true
			
			get_tree().create_timer(config.movementInterval).timeout.connect(checkForKill)
			
			while true:
				await GameState.flashlightOn 
				if GameState.playerState.facing == GameState.Facing.TOP_VENT:
					await GameState.wait(1)
					if GameState.playerState.flashlightOn and GameState.playerState.facing == GameState.Facing.TOP_VENT:
						break

				if lock == false:
					return # Player Probably Died

			lock = false
			currentStage = 0
			moveToStageMarker()

		killStage:
			jumpscare(config.intensity, config.decayRate, config.direction)
			playerKilled()

		_:
			print(
				"Invalid Stage Reached for Toy Bonnie Animatronic: " + 
				str(currentStage)
				)

func checkForKill() -> void:
	if currentStage == 2:
		currentStage = killStage # Killing Player
		lock = false
