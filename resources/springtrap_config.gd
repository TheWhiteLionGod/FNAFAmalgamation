"""
Config For Springtrap
"""
extends Resource
class_name SpringtrapConfig

@export var stages: int = 12;
@export var movementInterval: int = 2;

@export_group("Jumpscare")
@export var intensity: float = 0.8
@export var decayRate: float = 1.7
@export var direction: GameState.Facing = GameState.Facing.OFFICE