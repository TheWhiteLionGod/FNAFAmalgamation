"""
Config For Puppet
"""
extends Resource
class_name PuppetConfig

@export var stages: int = 2;

@export_group("Jumpscare")
@export var intensity: float = 0.8
@export var decayRate: float = 1.7