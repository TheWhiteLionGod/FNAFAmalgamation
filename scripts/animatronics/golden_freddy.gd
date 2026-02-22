"""
This Script Will Control Golden Freddy's Behavior
"""
extends Animatronic

@export_range(0, 20) var AI_LEVEL: int
@onready var killStage: int = getKillStage()
@onready var task: Label = Label.new()

@warning_ignore("INT_AS_ENUM_WITHOUT_CAST", "INT_AS_ENUM_WITHOUT_MATCH")
var curTask: Task = -1
var tasksCompleted: int = 0
var lock: bool = false

enum Task {
	LookLeft, LookUp, LookRight, WearMask, UseFlashlight, OpenCameras
}

func _init() -> void:
	super(3)

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
			
			var curCamera = randi_range(0, 10)
			# TODO: Move to Marker
			print(curCamera)

			while GameState.playerState.activeCamera != curCamera:
				await GameState.switchCamera
				await GameState.wait(0.1) # Ensuring Active Camera is Updated

			await GameState.wait(2)

			if GameState.playerState.activeCamera == curCamera and GameState.playerState.inCameras:
				currentStage += 1

			lock = false

		1:	
			if GameState.playerState.inCameras:
				await GameState.closeCamera
				get_tree().create_timer(5).timeout.connect(checkForKill)

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
				
				await GameState.wait(0.5)
				GameState.closeCamera.emit()

			else:
				print("Invalid Task for Golden Freddy")

			lock = false

		killStage:
			print("Golden Freddy Got You!")

		_:
			print(
				"Invalid Stage Reached for Golden Freddy Animatronic: " + 
				str(currentStage)
				)

func completeTask() -> void:
	tasksCompleted += 1
	if tasksCompleted >= 3:
		tasksCompleted = 0
		currentStage = 0
		task.text = ""

	@warning_ignore("INT_AS_ENUM_WITHOUT_CAST", "INT_AS_ENUM_WITHOUT_MATCH")
	curTask = -1

func checkForKill() -> void:
	if currentStage == 1: # Killing if Player Hasn't Completed All The Tasks
		currentStage = killStage
