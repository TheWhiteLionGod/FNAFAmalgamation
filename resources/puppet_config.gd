extends Resource
class_name PuppetConfig

@export var stages: int = 2;

@export_group("Jumpscare")
@export var intensity: float = 0.8
@export var decayRate: float = 1.7
@export var jumpscarePosOffset: Vector3 = Vector3(2.4,-1.55,0.075)