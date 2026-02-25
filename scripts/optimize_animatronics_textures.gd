@tool
extends EditorScript

const TARGET_DIR = "res://models/"
const SAVE_DIR = "res://optimized_meshes/"

func _run():
	print("oqiwheoqwhue")
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	
	_process_directory_recursive(TARGET_DIR)
	print("--- MASTER OPTIMIZATION COMPLETE. RESTART GODOT NOW ---")

func _process_directory_recursive(dir_path: String):
	var dir = DirAccess.open(dir_path)
	if not dir: return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir() and not file_name.begins_with("."):
			_process_directory_recursive(dir_path + file_name + "/")
		elif file_name.ends_with(".tscn"):
			_optimize_scene_file(dir_path + file_name)
		file_name = dir.get_next()

func _optimize_scene_file(path: String):
	var scene_res = load(path)
	if not scene_res is PackedScene: return
	
	var scene_root = scene_res.instantiate()
	_apply_optimizations(scene_root, scene_root)
	
	var packed = PackedScene.new()
	if packed.pack(scene_root) == OK:
		ResourceSaver.save(packed, path)
		print("Optimized & Saved: ", path)
	
	scene_root.free()

func _apply_optimizations(node: Node, scene_root: Node):
	if node is MeshInstance3D and node.mesh:
		# Use a unique name for the binary file based on the scene and node
		var mesh_id = str(node.get_instance_id())
		var save_path = SAVE_DIR + node.name.validate_filename() + "_" + mesh_id + ".res"
		
		# Save binary file and force path take-over
		ResourceSaver.save(node.mesh, save_path)
		node.mesh.take_over_path(save_path)
		node.mesh = load(save_path)

	for child in node.get_children():
		# CRITICAL: Every child must be owned by the scene root to be saved
		child.owner = scene_root
		_apply_optimizations(child, scene_root)
