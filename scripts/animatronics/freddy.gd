extends Animatronic
class_name Freddy

var interval: int = 10

func tick() -> void:
	if not Movement.on_interval(interval):
		return
	
	print("Hello World")
