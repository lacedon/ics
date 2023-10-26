extends Label

class_name WithDebugger

var _info: Dictionary = {}

func drawInfo() -> void:
	text = ''
	for key in _info:
		text += str(key, ': ', _info[key], '\n')

func _ready():
	if (!Game.shouldShowDebug): return

	size = Vector2(128, 16)

	var parent = get_parent()
	_info.parent = parent

	var withStateMachine: WithStateMachine = parent.withStateMachine if 'withStateMachine' in parent else null
	if (withStateMachine): withStateMachine.connect('stateChanged', _addStateMachineData)

	var withHealth: WithValue = parent.withHealth if 'withHealth' in parent else null
	if (withHealth):
		withHealth.connect('valueChanged', _addHealtData)
		withHealth.connect('maxValueChanged', _addHealtData)

func _addStateMachineData(state: State, _oldState: State):
	_info.state = state.getStateName()
	drawInfo()

func _addHealtData(health: int, maxHealth: int):
	_info.health = health
	_info.maxHealth = maxHealth
	drawInfo()

