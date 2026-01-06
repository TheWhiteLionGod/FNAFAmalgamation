extends StaticBody3D

@export var main: Node3D
@export var textureProgressBar: TextureProgressBar
@export var config: MusicBoxConfig

@onready var camera: Camera3D = main.get_node("Camera")

@onready var modules: Node = main.get_node("Modules")
@onready var Raycaster: Node3D = modules.get_node("Raycaster")

@onready var model: Node3D = get_node("Model")
@onready var winder: Node3D = model.get_node("Winder")

@onready var currentUnits: float = config.totalUnits
var isWindingUp: bool = false

func _ready() -> void:
	textureProgressBar.min_value = 0
	textureProgressBar.max_value = config.totalUnits
	textureProgressBar.step = config.totalUnits / 10.0
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
		currentUnits -= config.windDownUnitsPerSecond * delta
		currentUnits = clamp(currentUnits, 0, config.totalUnits)

		winder.rotation_degrees.x -= 1
	else:
		currentUnits += config.windUpUnitsPerSecond * delta
		currentUnits = clamp(currentUnits, 0, config.totalUnits)

		winder.rotation_degrees.x += 1
	
	textureProgressBar.value = currentUnits

func windUp() -> void:
	isWindingUp = true

func windDown() -> void:
	isWindingUp = false
