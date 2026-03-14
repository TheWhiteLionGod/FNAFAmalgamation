"""
Config For Mangle
"""
extends Resource
class_name WitheredConfig

@export var stages: int = 4;
@export var movementInterval: int = 30;

@export_group("Jumpscare")
@export var intensity: float = 0.8
@export var decayRate: float = 1.7
@export var direction: GameState.Facing = GameState.Facing.OFFICE