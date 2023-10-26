extends Node

class_name QuestManager

signal questUpdated(quests: Array)

@export var canvas: CanvasModulate
@export var questsParent: Node2D

const minReward: int = 100
const rewardStep: int = 100
const _quest = preload('res://components/other/Quest/Quest.tscn')

var _placingQuest: Node2D = null
var _quests: Array = []

func canCreateQuest() -> bool:
	return Resources.canUseResources({ gold = minReward })

func createQuest(type: String, payload: Variant = null) -> void:
	if (!canCreateQuest()):
		print('Cannot create a quest')
		return

	Resources.useResources({ gold = minReward })
	var quest = stopSettingQuest()
	questsParent.add_child(quest, Game.forceReadableNames)
	var questData = {
		object = quest,
		reward = minReward,
		type = type,
		payload = payload,
	}
	_quests.append(questData)
	prints('Quest is created:', questData)
	emit_signal("questUpdated")

func startSettingQuest() -> void:
	_placingQuest = _quest.instantiate()
	add_child(_placingQuest, Game.forceReadableNames)
	set_physics_process(true)

func stopSettingQuest() -> Node2D:
	var quest = _placingQuest
	set_physics_process(false)
	if (_placingQuest): remove_child(_placingQuest)
	_placingQuest = null
	return quest

func _ready():
	stopSettingQuest()

func _physics_process(_delta):
	_placingQuest.position = canvas.get_global_mouse_position()

func _enter_tree():
	EventEmitter.AddEmitter('questUpdated', self)
	EventEmitter.AddListener('clickOnBuilding', self, _on_clickOnBuilding)
	EventEmitter.AddListener('startCreatingQuest', self, _on_startCreatingQuest)

func _exit_tree():
	EventEmitter.RemoveEmitter('questUpdated', self)
	EventEmitter.RemoveListener('clickOnBuilding', self, _on_clickOnBuilding)
	EventEmitter.RemoveListener('startCreatingQuest', self, _on_startCreatingQuest)

func _on_startCreatingQuest():
	if (!canCreateQuest()):
		print('QuestManager: Cannot create a quest')
		return
	startSettingQuest()

func _on_clickOnBuilding(building: Node2D) -> void:
	if (_placingQuest):
		createQuest('attack', building)

func _input(event: InputEvent):
	if (
		_placingQuest &&
		event is InputEventMouseButton &&
		event.is_pressed() &&
		event.button_index == MOUSE_BUTTON_MASK_LEFT
	):
		await get_tree().process_frame
		if (_placingQuest): createQuest('scouting')
