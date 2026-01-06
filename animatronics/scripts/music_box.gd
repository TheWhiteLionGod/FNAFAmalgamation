extends StaticBody3D

@export var main: Node3D
@export var textureProgressBar: TextureProgressBar

@onready var camera: Camera3D = main.get_node("Camera")

@onready var modules: Node = main.get_node("Modules")
@onready var properties: Dictionary = modules.get_node("Properties").properties
@onready var Raycaster: Node3D = modules.get_node("Raycaster")

@onready var musicBoxProperties: Dictionary = properties["music_box"]
@onready var windDownUnitsPerSecond: int = musicBoxProperties["Wind_Down_Units_Per_Second"]
@onready var totalUnits: int = musicBoxProperties["Total_Units"]
@onready var windUpUnitsPerSecond: int = musicBoxProperties["Wind_Up_Units_Per_Second"]

@onready var model: Node3D = get_node("Model")
@onready var winder: Node3D = model.get_node("Winder")

@onready var currentUnits: float = totalUnits
var isWindingUp: bool = false

func _ready() -> void:
	textureProgressBar.min_value = 0
	textureProgressBar.max_value = totalUnits
	textureProgressBar.step = totalUnits / 10.0
	textureProgressBar.value = currentUnits

func _process(delta: float) -> void:
	# Check if the left mouse button is pressed continuously
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var result: Dictionary = Raycaster.raycastToMousePos(camera)

		if result:
			if result.collider.name == "MusicBox":
				windUp()
		else:
			windDown()
	else:
		windDown()
	
	# Wind down
	if not isWindingUp:
		currentUnits -= windDownUnitsPerSecond * delta
		currentUnits = clamp(currentUnits, 0, totalUnits)

		winder.rotation_degrees.x -= 1
	else:
		currentUnits += windUpUnitsPerSecond * delta
		currentUnits = clamp(currentUnits, 0, totalUnits)

		winder.rotation_degrees.x += 1
	
	textureProgressBar.value = currentUnits

func windUp() -> void:
	isWindingUp = true

func windDown() -> void:
	isWindingUp = false
