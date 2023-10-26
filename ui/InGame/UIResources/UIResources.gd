extends Control

@onready var _resourceData: Dictionary = {}

var _pattern = ': {{0}}'

func _ready():
	EventEmitter.AddListener('resourceUpdated', self, _updateResources)
	_initResourceView()

func _exit_tree():
	EventEmitter.RemoveListener('resourceUpdated', self, _updateResources)

func _initResourceView() -> void:
	for resourceName in Resources.resources:
		var wrapper = HBoxContainer.new()
		wrapper.name = str('Resource-', resourceName)
		wrapper.tooltip_text = str(resourceName[0].to_upper(), resourceName.substr(1,-1))

		var icon = TextureRect.new()
		icon.name = 'Icon'
		icon.texture = load(
			scene_file_path.replace(
				'UIResources.tscn',
				str('./icons/', resourceName, '.png')
			)
		)
		icon.custom_minimum_size = Vector2(14, 14)
		icon.size = Vector2(14, 14)
		wrapper.add_child(icon, Game.forceReadableNames)

		var label = Label.new()
		label.name = 'Label'
		label.text = _pattern.replace('{{0}}', str(Resources.resources[resourceName]))
		wrapper.add_child(label, Game.forceReadableNames)

		add_child(wrapper, Game.forceReadableNames)

		_resourceData[resourceName] = label

func _updateResources(resourceName: String, newValue: int, _oldValue: int) -> void:
	_resourceData[resourceName].text = _pattern.replace('{{0}}', str(newValue))
