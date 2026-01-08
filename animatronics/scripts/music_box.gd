"""
This Script will Handle the Music Box Mechanic
"""
extends StaticBody3D

@export var textureProgressBar: TextureProgressBar
@export var config: MusicBoxConfig

@onready var model: Node3D = get_node("Model")
@onready var winder: Node3D = model.get_node("Winder")

@onready var currentUnits: float = config.totalUnits

func _ready() -> void:
	currentUnits = config.totalUnits
	
	textureProgressBar.min_value = 0
	textureProgressBar.max_value = config.totalUnits
	
	textureProgressBar.step = config.totalUnits / 10.0
	textureProgressBar.value = currentUnits

func _process(delta: float) -> void:
	if currentUnits == 0:
		GameState.musicBoxEmpty.emit()

	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		windDown(delta)
		return
	
	var result: Dictionary = Raycaster.raycastToMousePos(GameState.curCamNode)
	if result == {} or result.collider != self:
		windDown(delta)
		return

	# Winds only if left clicking on music box
	windUp(delta)
	
func windUp(delta: float) -> void:
	# Updating Music Box Unit
	currentUnits += config.windUpUnitsPerSecond * delta
	currentUnits = clamp(currentUnits, 0, config.totalUnits)
	
	# Updating UI and Winder
	winder.rotation_degrees.x += 1
	textureProgressBar.value = currentUnits

func windDown(delta: float) -> void:
	# Updating Music Box Unit
	currentUnits -= config.windDownUnitsPerSecond * delta
	currentUnits = clamp(currentUnits, 0, config.totalUnits)
	
	# Updating UI and Winder
	winder.rotation_degrees.x -= 1
	textureProgressBar.value = currentUnits
