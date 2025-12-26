extends MarginContainer

var activeCamera: int = 0 # 0 - 10

func _process(_delta: float) -> void:
	pass

# Cam 1
func _on_button_pressed() -> void:
	activeCamera = 0

# Cam 2
func _on_button_2_pressed() -> void:
	activeCamera = 1

# Cam 3
func _on_button_3_pressed() -> void:
	activeCamera = 2

# Cam 4
func _on_button_4_pressed() -> void:
	activeCamera = 3

# Cam 5A
func _on_button_5a_pressed() -> void:
	activeCamera = 4

# Cam 5B
func _on_button_5b_pressed() -> void:
	activeCamera = 5

# Cam 5C
func _on_button_5c_pressed() -> void:
	activeCamera = 6

# Cam 6
func _on_button_6_pressed() -> void:
	activeCamera = 7

# Cam 7
func _on_button_7_pressed() -> void:
	activeCamera = 8

# Cam 8
func _on_button_8_pressed() -> void:
	activeCamera = 9

# Cam 9
func _on_button_9_pressed() -> void:
	activeCamera = 10
