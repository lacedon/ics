extends State

class_name BuildingStateBuilding

@export var buildingHealthStep: int = 7
@export var buildingTime: float = 0.25
@onready var _parent: Building = get_parent()
@onready var timer: Timer = _parent.timer
@onready var withHealth: WithValue = _parent.withHealth
@onready var withStateMachine: WithStateMachine = _parent.withStateMachine

func getStateName(): return 'Building'

func activate(_previousState: State):
	timer.connect('timeout', _on_timer_timeout)
	timer.wait_time = buildingTime
	timer.one_shot = true
	timer.start()

func deactivate(_nextState: State):
	timer.disconnect('timeout', _on_timer_timeout)
	timer.stop()

func _on_timer_timeout():
	if (withHealth.isFullValue()):
		withStateMachine.changeState(_parent.stateReady)
	else:
		withHealth.changeValue(buildingHealthStep)
		timer.start()
