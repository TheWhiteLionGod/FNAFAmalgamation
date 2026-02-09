class_name MovementOpportunity

var interval: int
var isDone: bool

@warning_ignore("SHADOWED_VARIABLE")
func _init(interval: int):
    self.interval = interval
    isDone = false

func check(AI_LEVEL: int) -> bool:
    var curTime = GameState.globalTimer
    curTime = round(curTime * 10) / 10
    
    # NOT Movement Opportunity
    if int(curTime) % interval != 0 or curTime - int(curTime) != 0:
        isDone = false # Resetting Boolean
        return false

    if isDone:
        return false
    isDone = true

    if randi_range(0, 20) >= AI_LEVEL:
        return false # Failed Movement

    return true
