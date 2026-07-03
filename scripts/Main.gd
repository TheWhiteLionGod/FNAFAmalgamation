extends Node3D

@onready var animatronics: Node3D = $"Animatronics"
@export var animatronics_to_load: Array[PackedScene] = []

func _ready() -> void:
	Global.rooms = get_node_or_null("Rooms")
	for animatronic_scene: PackedScene in animatronics_to_load:
		var animatronic: Animatronic = animatronic_scene.instantiate() as Animatronic
		animatronics.add_child(animatronic)
		animatronic.move_to_start()

func _process(delta: float) -> void:
	Movement.tick(delta)
	for animatronic: Animatronic in animatronics.get_children():
		animatronic.tick()
