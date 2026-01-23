"""
Abstract Class to Handle Animatronic Behavior
"""
extends Skeleton3D
class_name Animatronic

enum Stage {
	ZERO, ONE, KILL
}

var currentStage: Stage = Stage.ZERO
var killed: bool = false

# Making Animatronics Class Abstract
func _init() -> void:
	assert(get_script() != preload("res://animatronics/scripts/animatronics.gd"), 
	"Animatronic Class is abstract and cannot be instantiated.")

# Making handleStage Method Abstract
func handleStage() -> void:
	@warning_ignore("assert_always_false")
	assert(false, "Handle Stage Method is Abstract and Must be Overriten")

## Spawn animatronic into main scene (Method might not be needed)
# func spawn(main: Node3D) -> void:
# 	var path: String = self.scene_file_path
# 	var sceneResource: Resource = load(path)
# 	var clone: Node3D = sceneResource.instantiate()

# 	main.add_child(clone)

func playerKilled():
	GameState.playerKilled.emit()
	killed = true

## Jumpscare
func jumpscare(player: Node3D, intensity: float = 1, decayRate: float = 0.8, jumpscarePosOffset: Vector3 = Vector3.ZERO):
	if GameState.playerActions["cameras"]:
		GameState.closeCamera.emit()
	
	# Shake Screen
	GameState.shakeScreen.emit(intensity, decayRate)
	
	self.global_position = player.position + jumpscarePosOffset
	$"AnimationPlayer".play("jumpscare")
	
func _ready() -> void:
	currentStage = Stage.ZERO

func _process(_delta: float) -> void:
	if killed: return
	handleStage()
