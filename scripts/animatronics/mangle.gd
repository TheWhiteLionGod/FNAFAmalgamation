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
	GameState.flashlightOn.connect(useFlashlight)

func handleStage() -> void:
	match currentStage:
		0, 1:
			if lock:
				return

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
				"Invalid Stage Reached for Mangle Animatronic: " + 
				str(currentStage)
				)

func checkForKill() -> void:
	if currentStage == 2:
		currentStage = killStage # Killing Player
		lock = false

func useFlashlight() -> void:
	if currentStage != 2:
		# Camera Stunning
		if !GameState.playerState.inCameras:
			return

		if currentStage == 0 and GameState.playerState.activeCamera != 5:
			return

		if currentStage == 1 and GameState.playerState.activeCamera != 8:
			return

		lock = true
		await GameState.wait(7) # Stunning for 7 Seconds
		lock = false
		return

	if GameState.playerState.facing != GameState.Facing.TOP_VENT:
		return # Player Isn't Facing Mangle

	await GameState.wait(0.5)
	
	if GameState.playerState.flashlightOn and GameState.playerState.facing == GameState.Facing.TOP_VENT:
		lock = false
		currentStage = 0
		moveToStageMarker()
