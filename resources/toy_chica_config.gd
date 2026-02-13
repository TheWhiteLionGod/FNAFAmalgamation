"""
Config For Toy Chica
"""
extends Resource
class_name ToyChicaConfig

@export var stages: int = 4;
@export var movementInterval: int = 5;
@export var blackoutLength: int = 4;

@export_group("Jumpscare")
@export var intensity: float = 0.8
@export var decayRate: float = 1.7
@export var direction: GameState.Facing = GameState.Facing.OFFICE