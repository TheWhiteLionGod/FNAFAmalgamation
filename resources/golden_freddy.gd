"""
Config For Toy Freddy
"""
extends Resource
class_name GoldenFreddyConfig

@export var stages: int = 3
@export var tasksToComplete: int = 4
@export var timeToEnterOffice: int = 1
@export var timeToCompleteTask: int = 5

@export_group("Jumpscare")
@export var intensity: float = 1.5
@export var decayRate: float = 1.3
@export var direction: GameState.Facing = GameState.Facing.OFFICE