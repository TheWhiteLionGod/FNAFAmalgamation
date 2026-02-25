extends Node

@onready var db: Database = Database.new(get_tree().current_scene)

func _ready() -> void:
	# Small delay to ensure the node is fully in the scene tree
	await get_tree().process_frame
	db.addData(["Test", 500])
