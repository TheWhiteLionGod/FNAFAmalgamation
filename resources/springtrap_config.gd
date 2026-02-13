"""
Config For Springtrap
"""
extends Resource
class_name SpringtrapConfig

@export var stages: int = 12;
@export var movementInterval: int = 10;

@export_group("Jumpscare")
@export var intensity: float = 0.1
@export var decayRate: float = 1.7
@export var direction: GameState.Facing = GameState.Facing.OFFICE