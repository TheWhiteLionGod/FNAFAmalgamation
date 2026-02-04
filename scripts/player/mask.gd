"""
This Script Controls the Player Putting On and Off The Mask
"""
extends Node3D

@onready var maskAnimationPlayer: AnimationPlayer = get_parent().get_node("AnimationPlayer")
@onready var equipMaskAnimation: Animation = maskAnimationPlayer.get_animation("equip_mask")
@onready var unequipMaskAnimation: Animation = maskAnimationPlayer.get_animation("unequip_mask")

var adjustingMask: bool = false

func _ready() -> void:
	GameState.maskOn.connect(putMaskOn)
	GameState.maskOff.connect(takeMaskoff)

func putMaskOn() -> void:
	if adjustingMask: 
		return

	adjustingMask = true
	visible = true
	maskAnimationPlayer.play("equip_mask")

	await maskAnimationPlayer.animation_finished

	adjustingMask = false

func takeMaskoff() -> void:
	if adjustingMask: return

	adjustingMask = true
	maskAnimationPlayer.play("unequip_mask")
	
	await maskAnimationPlayer.animation_finished
	
	visible = false
	adjustingMask = false
