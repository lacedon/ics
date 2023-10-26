extends State
class_name BuildingStateReady

@onready var _parent: Building = get_parent()
@onready var withHealth: WithValue = _parent.withHealth

func getStateName(): return 'Ready'

func activate(previousState: State):
	if (!previousState && withHealth.value == withHealth.minValue):
		withHealth.setValue(withHealth.maxValue)

func deactivate(_nextState: State):
	pass
