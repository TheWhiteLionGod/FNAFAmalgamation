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

	# Cannot move further than jumpscare
	if currentStage > len(markers):
		return

	var marker: Marker3D = markers[currentStage]

	visible = true	
	global_transform = marker.global_transform

	if !marker.get_meta("anim").is_empty():
		$"AnimationPlayer".play(marker.get_meta("anim"))
	else:
		$"AnimationPlayer".play("RESET")

func playerKilled():
	GameState.playerKilled.emit()

func restartGame():
	for connection in get_incoming_connections():
		var sourceSignal = connection["signal"]
		var targetCallable = connection["callable"]
		
		if sourceSignal.is_connected(targetCallable):
			sourceSignal.disconnect(targetCallable)
	
	self._ready()

	# Update music box
	get_tree().current_scene.get_node("Animatronics").get_node("MusicBox")._ready()

## Jumpscare
func jumpscare(
	intensity: float = 1, 
	decayRate: float = 0.8,  
	direction: GameState.Facing = GameState.Facing.OFFICE):

	if GameState.playerState.inCameras:
		GameState.closeCamera.emit()
	if GameState.playerState.maskOn:
		GameState.maskOff.emit()
	
	GameState.turn.emit(direction)
	
	# Shake Screen
	GameState.shakeScreen.emit(intensity, decayRate)
	
	# Moves animatronic to final marker (should be jumpscare marker)
	$"AnimationPlayer".play("jumpscare")

	var markers: Array[Node] = getMarkers()
	global_transform = markers[len(markers) - 1].global_transform
	
func _ready() -> void:
	currentStage = 0
	moveToStageMarker()

	GameState.restartGame.connect(restartGame)

func _process(_delta: float) -> void:
	if !GameState.playerState.playerDead:
		handleStage()
