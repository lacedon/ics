extends Control

signal startCreatingQuest()

@onready var _questList: ItemList = $QuestList
@onready var _createQuestButton: Button = $CreateQuest

var _icons = {
	attack = preload("./icons/attack.png"),
	scouting = preload("./icons/scouting.png"),
	tree = preload("./icons/tree.png"),
}

func _ready():
	_createQuestButton.connect("button_up", _createQuest)

func _enter_tree():
	EventEmitter.AddEmitter('startCreatingQuest', self)
	EventEmitter.AddListener('questUpdated', self, _on_questUpdated)

func _exit_tree():
	EventEmitter.RemoveEmitter('startCreatingQuest', self)
	EventEmitter.RemoveListener('questUpdated', self, _on_questUpdated)

func _createQuest():
	emit_signal('startCreatingQuest')

func _on_questUpdated(quests: Array):
	_questList.clear()
	for quest in quests:
		var title
		match quest.type:
			'attack': title = str('Attack ', quest.payload.name)
			'scouting': title = str('Explore a territory')
			'tree': title = str('Get some wood')
		_questList.add_item(str(title, ': ', quest.reward, 'g.'), _icons[quest.type])
