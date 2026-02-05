"""
Config For Toy Freddy
"""
extends Resource
class_name ToyFreddyConfig

@export var stages: int = 3;
@export var movementInterval: int = 10;
@export var blackoutLength: int = 5;

@export_group("Jumpscare")
@export var intensity: float = 0.8
@export var decayRate: float = 1.7
@export var direction: GameState.Facing = GameState.Facing.OFFICE