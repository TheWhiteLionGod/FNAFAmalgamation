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
	visible = false
	assert(get_script() != preload("res://animatronics/scripts/animatronics.gd"), 
	"Animatronic Class is abstract and cannot be instantiated.")

# Making handleStage Method Abstract
func handleStage() -> void:
	@warning_ignore("assert_always_false")
	assert(false, "Handle Stage Method is Abstract and Must be Overriten")

## Spawn animatronic into main scene (Method will probably never be needed)
# func spawn(main: Node3D) -> void:
# 	var path: String = self.scene_file_path
# 	var sceneResource: Resource = load(path)
# 	var clone: Node3D = sceneResource.instantiate()

# 	main.add_child(clone)

## Get all markers that are representing the move coordinates in an ordered array
func getMarkers() -> Array[Node]:
	print(get_script().get_path().get_file().replace(".gd", ""))
	var animatronicID: String = get_script().get_path().get_file().replace(".gd", "")

	var markers: Array = get_tree().get_nodes_in_group(animatronicID)
	markers.sort_custom(func(a, b): return a.name.naturalnocasecmp_to(b.name) < 0)
 
	return markers

## Needs to be global transform for intended effects
## If animatronic is already at last marker, then nothing will happen
func moveToStageMarker():
	var markers: Array[Node] = getMarkers()

	# Cannot move further
	if currentStage > len(markers) - 1:
		return

	visible = true
	global_transform = markers[currentStage].global_transform

func playerKilled():
	killed = true

## Jumpscare
func jumpscare(player: Node3D, intensity: float = 1, decayRate: float = 0.8, jumpscarePosOffset: Vector3 = Vector3.ZERO):
	# Shake Screen
	GameState.shakeScreen.emit(intensity, decayRate)
	
	global_position = player.position + jumpscarePosOffset
	$"AnimationPlayer".play("jumpscare")
	
func _ready() -> void:
	currentStage = Stage.ZERO

func _process(_delta: float) -> void:
	if killed:
		return

	handleStage()
