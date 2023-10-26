extends Node

class_name BuilderManager

@export var canvas: CanvasModulate
@export var buildingParent: Node2D

var _buildingInstance: Node = null

func canCreateBuilding():
	return _buildingInstance.canBeBuild()

func createBuilding():
	if (!canCreateBuilding()):
		print('Cannot build ', _buildingInstance.name)
		return

	var building = stopSettingBuilding()
	buildingParent.add_child(building, Game.forceReadableNames)
	building.build()
	print('Building "', building.name, '" is builded')

func startSettingBuilding(building: PackedScene):
	_buildingInstance = building.instantiate()
	_buildingInstance.startPlacing()
	add_child(_buildingInstance, Game.forceReadableNames)
	set_physics_process(true)

func stopSettingBuilding():
	var building = _buildingInstance
	set_physics_process(false)
	if (_buildingInstance): remove_child(_buildingInstance)
	_buildingInstance = null
	return building

func _ready():
	stopSettingBuilding()

func _enter_tree():
	EventEmitter.AddListener('startPlacingBuilding', self, _onStartPlacingBuilding)

func _exit_tree():
	EventEmitter.RemoveListener('startPlacingBuilding', self, _onStartPlacingBuilding)

func _physics_process(_delta):
	_buildingInstance.position = canvas.get_global_mouse_position()

func _onStartPlacingBuilding(building: PackedScene, _source: String):
	startSettingBuilding(building)

func _input(event: InputEvent):
	if (
		_buildingInstance &&
		event is InputEventMouseButton &&
		event.is_pressed()
	):
		match event.button_index:
			MOUSE_BUTTON_MASK_LEFT: createBuilding()
			MOUSE_BUTTON_MASK_RIGHT: stopSettingBuilding()
