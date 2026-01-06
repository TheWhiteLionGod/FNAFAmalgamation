extends Node3D

@onready var cameras: Node = get_node("Cameras")
@onready var currentCamera: Camera3D = cameras.get_node(GameState.Camera.find_key(GameState.activeCamera))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_switch_camera()
	GameState.switchCamera.connect(_on_switch_camera)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_switch_camera() -> void:
	currentCamera.current = false

	var camera: Camera3D = cameras.get_node(GameState.Camera.find_key(GameState.activeCamera))
	camera.current = true

	currentCamera = camera
