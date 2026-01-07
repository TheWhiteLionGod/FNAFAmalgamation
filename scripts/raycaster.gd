"""
Raycaster Class which will Handle Raycasts within the Game
"""
extends Node3D
class_name Raycaster

# Send Raycast from Current Camera to Mouse Position
static func raycastToMousePos(camera: Camera3D) -> Dictionary:
	var space_state = camera.get_world_3d().direct_space_state
	var mouse_pos = camera.get_viewport().get_mouse_position()

	# Cast a ray from the camera to the mouse position
	var ray_start = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_start + camera.project_ray_normal(mouse_pos) * 1000

	# Corrected: Call PhysicsRayQueryParameters3D directly
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	
	# Use the world's space_state to intersect
	var result = space_state.intersect_ray(query)

	return result
