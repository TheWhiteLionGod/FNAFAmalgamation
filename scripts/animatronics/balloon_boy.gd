"""
This Script Will Control Balloon Boy's Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int
@export var config: BBConfig:
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
	GameState.maskOn.connect(maskOn)
	GameState.flashlightOn.connect(useFlashlight)

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

		killStage:
			jumpscare(config.intensity, config.decayRate, config.direction)
			playerKilled()

		_:
			print(
				"Invalid Stage Reached for Balloon Boy Animatronic: " + 
				str(currentStage)
				)

func checkForKill() -> void:
	if currentStage == 2:
		currentStage = killStage # Killing Player
		lock = false

func maskOn() -> void:
	if currentStage != 2: # Making Sure BB is in Vent
		return

	if GameState.playerState.facing != GameState.Facing.TOP_VENT:
		return # Player Isn't Facing BB

	await GameState.wait(0.5)
	
	if GameState.playerState.maskOn and GameState.playerState.facing == GameState.Facing.TOP_VENT:
		lock = false
		currentStage = 0
		moveToStageMarker()

func useFlashlight() -> void:
	if currentStage != 2:
		return

	if GameState.playerState.facing != GameState.Facing.TOP_VENT:
		return

	# TODO: Disable Flashlight
