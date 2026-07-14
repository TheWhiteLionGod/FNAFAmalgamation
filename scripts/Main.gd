extends Node3D

@onready var animatronics_node: Node3D = $"Animatronics"
@export var animatronic_data: Array[AnimatronicData] = []

func _ready() -> void:
	Global.rooms = get_node_or_null("Rooms")
	for data: AnimatronicData in animatronic_data:
		var animatronic: Animatronic = data.animatronic_scene.instantiate() as Animatronic
		animatronic.config = data.default_config

		animatronics_node.add_child(animatronic)
		animatronic.move_to_start()

func _process(delta: float) -> void:
	Movement.tick(delta)
	for animatronic: Animatronic in animatronics_node.get_children():
		animatronic.tick()
