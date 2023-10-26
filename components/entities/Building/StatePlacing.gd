extends State
class_name BuildingStatePlacing

@export var allowBuildingColor: Color = Color(0.5, 1, 0.5, 0.75)
@export var blockBuildingColor: Color = Color(1, 0.5, 0.5, 0.75)
@onready var _parent: Building = get_parent()
@onready var entityCollision: Area2D = _parent.entityCollision
var _enteredCount: int = 0

func getStateName(): return 'Placing'

func activate(_previousState: State):
	entityCollision.connect('area_entered', _on_building_area_entered)
	entityCollision.connect('area_exited', _on_building_area_exited)
	_updateBuildingStatus()

func deactivate(_nextState: State):
	entityCollision.disconnect('area_entered', _on_building_area_entered)
	entityCollision.disconnect('area_exited', _on_building_area_exited)
	_parent.modulate = Color(1, 1, 1, 1)

func canBeBuild():
	return _enteredCount == 0

func _updateBuildingStatus():
	if (canBeBuild()):
		_parent.modulate = allowBuildingColor
	else:
		_parent.modulate = blockBuildingColor

func _on_building_area_entered(_area: Area2D):
	_enteredCount += 1
	_updateBuildingStatus()

func _on_building_area_exited(_area: Area2D):
	_enteredCount -= 1
	_updateBuildingStatus()
