"""
Abstract Class to Handle Animatronic Behavior
"""
extends Skeleton3D
class_name Animatronic

@onready var player: Node3D = GameState.playerNode

# Instance Variables
var stages: int # Including Kill Stage

var currentStage: int = 0

# Making Animatronics Class Abstract
@warning_ignore("SHADOWED_VARIABLE")
func _init(stages: int = 3) -> void:
	self.stages = stages
	visible = false

	assert(get_script() != preload("res://scripts/animatronics/animatronics.gd"), 
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

## Kill Stage
func getKillStage() -> int:
	return stages - 1

## Get all markers that are representing the move coordinates in an ordered array
func getMarkers() -> Array[Node]:
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

	var marker: Marker3D = markers[currentStage]

	visible = true	
	global_transform = marker.global_transform

	if !marker.get_meta("anim").is_empty():
		$"AnimationPlayer".play(marker.get_meta("anim"))

func playerKilled():
	GameState.playerKilled.emit()

## Jumpscare
func jumpscare(intensity: float = 1, decayRate: float = 0.8, jumpscarePosOffset: Vector3 = Vector3.ZERO):
	if GameState.playerActions["cameras"]:
		GameState.closeCamera.emit()
	if GameState.playerActions["mask"]:
		GameState.maskOff.emit()
	
	# Shake Screen
	GameState.shakeScreen.emit(intensity, decayRate)
	
	global_position = player.position + jumpscarePosOffset
	$"AnimationPlayer".play("jumpscare")
	
func _ready() -> void:
	currentStage = 0
	moveToStageMarker()

func _process(_delta: float) -> void:
	if GameState.playerDead: 
		return
	
	handleStage()
