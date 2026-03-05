"""
This Script Will Control Golden Freddy's Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int
@export var config: GoldenFreddyConfig:
	set(value):
		config = value
		configReady.emit()

@onready var killStage: int = getKillStage()
@onready var task: Label = Label.new()

@warning_ignore("INT_AS_ENUM_WITHOUT_CAST", "INT_AS_ENUM_WITHOUT_MATCH")
var curTask: Task = -1 

@warning_ignore("INT_AS_ENUM_WITHOUT_CAST")
var curCamera: GameState.Camera = 0
var tasksCompleted: int = 0
var lock: bool = false

enum Task {
	LookLeft, LookUp, LookRight, WearMask, UseFlashlight, OpenCameras
}

func _init() -> void:
	await configReady
	super(config.stages)

func _ready() -> void:
	@warning_ignore("INT_AS_ENUM_WITHOUT_CAST", "INT_AS_ENUM_WITHOUT_MATCH")
	curTask = -1
	tasksCompleted = 0
	lock = false

	add_child(task)
	super._ready()

func handleStage() -> void:
	match currentStage:
		0: 
			if lock:
				return
			
			lock = true
			await GameState.openCamera
			
			@warning_ignore("INT_AS_ENUM_WITHOUT_CAST")
			curCamera = randi_range(0, 10)
			moveToStageMarker()

			while GameState.playerState.activeCamera != curCamera:
				await GameState.switchCamera
				await GameState.wait(0.1) # Ensuring Active Camera is Updated

			await GameState.wait(config.timeToEnterOffice)

			if GameState.playerState.activeCamera == curCamera and GameState.playerState.inCameras:
				currentStage += 1
				@warning_ignore("INT_AS_ENUM_WITHOUT_CAST")
				curCamera = 10

			lock = false

		1:	
			visible = true
			moveToStageMarker()

			if GameState.playerState.inCameras:
				await GameState.closeCamera
				get_tree().create_timer(config.timeToCompleteTask).timeout.connect(checkForKill)

			if curTask == -1:
				@warning_ignore("INT_AS_ENUM_WITHOUT_CAST")
				curTask = randi_range(0, 5)

			if randi_range(1, 10) == 1:
				task.text = Task.keys()[curTask]
				task.position = Vector2(randi_range(250, 750), randi_range(250, 750))
				task.set("theme_override_colors/font_shadow_color", Color(0, 0, 0))
				task.set("theme_override_font_sizes/font_size", 40)

			if lock:
				return
			lock = true

			if curTask == Task.LookLeft:
				await GameState.turn
				await GameState.wait(0.1) # Ensuring Direction is Updated
				
				if GameState.playerState.facing == GameState.Facing.TABLE:
					completeTask()
					await GameState.wait(0.25)
					GameState.turn.emit(GameState.Facing.OFFICE)
		
			elif curTask == Task.LookUp:
				await GameState.turn
				await GameState.wait(0.1) # Ensuring Direction is Updated
				
				if GameState.playerState.facing == GameState.Facing.TOP_VENT:
					completeTask()
					await GameState.wait(0.25)
					GameState.turn.emit(GameState.Facing.OFFICE)

			elif curTask == Task.LookRight:
				await GameState.turn
				await GameState.wait(0.1) # Ensuring Direction is Updated
				
				if GameState.playerState.facing == GameState.Facing.MUSIC_BOX:
					completeTask()
					await GameState.wait(0.25)
					GameState.turn.emit(GameState.Facing.OFFICE)

			elif curTask == Task.WearMask:
				await GameState.maskOn
				completeTask()
				
				await GameState.wait(0.5)
				GameState.maskOff.emit()

			elif curTask == Task.UseFlashlight:
				await GameState.flashlightOn
				completeTask()

			elif curTask == Task.OpenCameras:
				await GameState.openCamera
				completeTask()
				
				await GameState.wait(0.1)
				GameState.closeCamera.emit()

			else:
				print("Invalid Task for Golden Freddy")

			lock = false

		killStage:
			jumpscare(config.intensity, config.decayRate, config.direction)
			playerKilled()
			task.text = ""

		_:
			print(
				"Invalid Stage Reached for Golden Freddy Animatronic: " + 
				str(currentStage)
				)

func completeTask() -> void:
	tasksCompleted += 1
	if tasksCompleted >= config.tasksToComplete:
		tasksCompleted = 0
		currentStage = 0
		task.text = ""
		visible = false
		GameState.goldenFreddyCleared.emit()

	@warning_ignore("INT_AS_ENUM_WITHOUT_CAST", "INT_AS_ENUM_WITHOUT_MATCH")
	curTask = -1

func checkForKill() -> void:
	if currentStage == 1: # Killing if Player Hasn't Completed All The Tasks
		currentStage = killStage
		tasksCompleted = 0 # Preventing Player From Clearing Golden Freddy After Kill

func moveToStageMarker():
	var markers: Array[Node] = getMarkers()

	var marker: Marker3D = markers[curCamera + currentStage]


	visible = true	
	global_transform = marker.global_transform

	if !marker.get_meta("anim").is_empty():
		$"AnimationPlayer".play(marker.get_meta("anim"))
	else:
		$"AnimationPlayer".play("RESET")
