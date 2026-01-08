"""
Abstract Class to Handle Animatronic Behavior
"""
extends Skeleton3D
class_name Animatronic

enum Stage {
	ZERO, ONE, KILL
}

var currentStage: Stage = Stage.ZERO

# Making Animatronics Class Abstract
func _init() -> void:
	assert(get_script() != preload("res://animatronics/scripts/animatronics.gd"), 
	"Animatronic Class is abstract and cannot be instantiated.")

# Making handleStage Method Abstract
func handleStage() -> void:
	@warning_ignore("assert_always_false")
	assert(false, "Handle Stage Method is Abstract and Must be Overriten")

func _ready() -> void:
	currentStage = Stage.ZERO

func _process(_delta: float) -> void:
	handleStage()
