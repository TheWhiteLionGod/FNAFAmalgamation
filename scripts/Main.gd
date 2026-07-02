extends Node3D

@onready var animatronics: Node3D = $"Animatronics"

func _ready() -> void:
	Global.rooms = get_node_or_null("Rooms")
	for animatronic: Animatronic in animatronics.get_children():
		animatronic.move_to_start()

func _process(delta: float) -> void:
	Movement.tick(delta)
	for animatronic: Animatronic in animatronics.get_children():
		animatronic.tick()
