"""
This Script Will Control Springtrap Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int
@export var config: SpringtrapConfig:
	set(value):
		config = value
		configReady.emit()

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var movementOpportunity: MovementOpportunity

func _init():
	await configReady
	super(config.stages)
	movementOpportunity = MovementOpportunity.new(config.movementInterval)

func _ready() -> void:
	super._ready()
	GameState.placeAudioLure.connect(listenToAudioLure)

	# Resetting Springtrap when Clearing Golden Freddy
	GameState.goldenFreddyCleared.connect(func(): currentStage = rng.randi_range(4, 10))

	# Spawning in Random Camera
	currentStage = rng.randi_range(4, 10)
	moveToStageMarker()

func handleStage() -> void:
	match currentStage:
		4, 5, 6, 7, 8, 9, 10:
			# Failed Movement
			if !movementOpportunity.check(AI_LEVEL):
				return

			# Moving 2 Cams Forward / Backwards
			currentStage -= rng.randi_range(2, -1)
			currentStage = min(max(currentStage, 0), 10)
			moveToStageMarker()

		# Vents Kill
		2, 3:
			# Failed Movement
			if !movementOpportunity.check(AI_LEVEL):
				return
			
			# Kills Player
			if currentStage != GameState.sealedCam:
				currentStage = -1
				return

			# Springtrap Can Leave, Stay in Vent, or Rush Door From Here
			currentStage += rng.randi_range(-1, 1) * 2
			currentStage = min(max(currentStage, 0), 11)
			moveToStageMarker()

		# Door Kill
		0, 1: 
			# Failed Movement
			if !movementOpportunity.check(AI_LEVEL):
				return

			# Right Door
			if currentStage == 1 and !GameState.playerState.rightDoorClosed:
				currentStage = -1
				return
			
			elif currentStage == 0 and !GameState.playerState.leftDoorClosed:
				currentStage = -1
				return
			
			# Clearing Springtrap
			currentStage = rng.randi_range(4, 10)
			moveToStageMarker()

		-1:
			jumpscare(config.intensity, config.decayRate, config.direction)
			playerKilled()

		_:
			print(
				"Invalid Stage Reached for Springtrap Animatronic: " + 
				str(currentStage)
				)

func listenToAudioLure(luredCamera: GameState.Camera) -> void:
	@warning_ignore("INT_AS_ENUM_WITHOUT_CAST")
	var probOfListening: float = float(1) / float(abs(currentStage - luredCamera) + 1)

	if rng.randf() >= probOfListening:
		return # Lure Failed

	currentStage = luredCamera
	moveToStageMarker()
