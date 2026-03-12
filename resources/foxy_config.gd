"""
Config For Foxy
"""
extends Resource
class_name FoxyConfig

@export var stages: int = 3;
@export var movementInterval: int = 20;

@export_group("Jumpscare")
@export var intensity: float = 0.1
@export var decayRate: float = 1.7
@export var direction: GameState.Facing = GameState.Facing.OFFICE