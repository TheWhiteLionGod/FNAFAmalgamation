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
var hasMoved: bool = false

func _init():
	await configReady
	super(config.stages)

func _ready() -> void:
	super._ready()
	# Spawning in Any Camera Other Than Door & Vent Camera
	currentStage = rng.randi_range(0, 7)
	moveToStageMarker()

func handleStage() -> void:
	print(currentStage)
	match currentStage:
		0, 1, 2, 3, 4, 5, 6, 7:
			var curTime = GameState.globalTimer
			curTime = round(curTime * 10) / 10
			
			# NOT Movement Opportunity
			if int(curTime) % config.movementInterval != 0 or curTime - int(curTime) != 0:
				hasMoved = false # Resetting Boolean
				return

			if hasMoved:
				return
			
			# This is a Movement Opportunity
			hasMoved = true
			if randi_range(0, 20) >= AI_LEVEL:
				return; # Failed Movement

			# Moving 2 Cams Forward / Backwards
			currentStage += rng.randi_range(2, -1)
			currentStage = min(max(currentStage, 0), 11)
			moveToStageMarker()

		# Vents Kill
		8, 9:
			pass

		# Door Kill
		10, 11:
			pass

		_:
			print(
				"Invalid Stage Reached for Springtrap Animatronic: " + 
				str(currentStage)
				)
