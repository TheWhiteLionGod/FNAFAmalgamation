extends Node3D

@onready var maskAnimationPlayer: AnimationPlayer = get_parent().get_node("AnimationPlayer")
@onready var equipMaskAnimation: Animation = maskAnimationPlayer.get_animation("equip_mask")
@onready var unequipMaskAnimation: Animation = maskAnimationPlayer.get_animation("unequip_mask")

var adjustingMask: bool = false

func _ready() -> void:
	GameState.maskOn.connect(putMaskOn)
	GameState.maskOff.connect(takeMaskoff)

func putMaskOn() -> void:
	if adjustingMask || GameState.playerActions["cameras"]: 
		return

	adjustingMask = true
	visible = true
	maskAnimationPlayer.play("equip_mask")

	await get_tree().create_timer(equipMaskAnimation.length).timeout
	adjustingMask = false

func takeMaskoff() -> void:
	if adjustingMask: return

	adjustingMask = true
	maskAnimationPlayer.play("unequip_mask")
	
	await get_tree().create_timer(unequipMaskAnimation.length).timeout
	visible = false
	adjustingMask = false
