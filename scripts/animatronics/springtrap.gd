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

	# Spawning in Any Camera Other Than Door & Vent Camera
	currentStage = rng.randi_range(0, 5)
	moveToStageMarker()

func handleStage() -> void:
	match currentStage:
		0, 1, 2, 3, 4, 5, 6, 7:
			# Failed Movement
			if !movementOpportunity.check(AI_LEVEL):
				return

			# Moving 2 Cams Forward / Backwards
			currentStage += rng.randi_range(2, -1)
			currentStage = min(max(currentStage, 0), 11)
			moveToStageMarker()

		# Vents Kill
		8, 9:
			currentStage += 1;

		# Door Kill
		10, 11:			
			jumpscare(config.intensity, config.decayRate, config.direction)
			playerKilled()

		_:
			print(
				"Invalid Stage Reached for Springtrap Animatronic: " + 
				str(currentStage)
				)

func listenToAudioLure(luredCamera: GameState.Camera) -> void:
	@warning_ignore("INT_AS_ENUM_WITHOUT_CAST")
	var curCamera: GameState.Camera = 10 - currentStage
	var probOfListening: float = float(1) / float(abs(curCamera - luredCamera) + 1)

	if rng.randf() > probOfListening:
		return # Lure Failed

	currentStage = 10 - luredCamera
	moveToStageMarker()
