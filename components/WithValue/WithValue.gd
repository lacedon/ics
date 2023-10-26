extends Node

class_name WithValue

signal valueChanged(value: int, maxValue: int, minValue: int)
signal maxValueChanged(value: int, maxValue: int, minValue: int)

@export var valueBar: Range
@export var minValue: int = 0
@export var maxValue: int = 100
@export var value: int = 0

static func passGetValue(node: WithValue) -> int: return node.value if node else 0
static func passGetMaxValue(node: WithValue) -> int: return node.maxValue if node else 0
static func passSetValue(node: WithValue, newValue: int):
	await node.get_parent().ready
	node.setValue(newValue)
static func passSetMaxValue(node: WithValue, newValue: int):
	await node.get_parent().ready
	node.setMaxValue(newValue)

func changeValue(newValue: int): setValue(value + newValue)
func changeMaxValue(newValue: int): setMaxValue(maxValue + newValue)

func setValue(newValue: int, silent: bool = false):
	var oldValue = value
	value = max(minValue, min(newValue, maxValue))
	if (valueBar): valueBar.value = value
	if (!silent && oldValue != value): emit_signal('valueChanged', value, maxValue, minValue)

func setMaxValue(newValue: int, silent: bool = false):
	var oldMaxValue = maxValue
	maxValue = max(minValue, newValue)
	if (value > newValue): setValue(value)
	if (valueBar): valueBar.max_value = maxValue
	if (!silent && oldMaxValue != maxValue): emit_signal('maxValueChanged', value, maxValue, minValue)

func isFullValue() -> bool:
	return value == maxValue

func _ready():
	setValue(value, true)
	setMaxValue(maxValue, true)
