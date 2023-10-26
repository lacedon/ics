extends Control

@export var dummyButtonTexture: Resource;
@export var maxButtonNumber: int = 10
@export var buildButtonScript: Resource;

func setupInventory(inventory: Array) -> void:
	var inventorySize = inventory.size()
	for index in maxButtonNumber:
		var btn = get_child(index)
		_resetButton(btn)
		var cell = inventory[index] if index < inventorySize else null
		if (cell):
			match cell.type:
				"building": _setBuildinButton(btn, cell)

func _ready():
	for index in maxButtonNumber:
		var btn = Button.new()
		_resetButton(btn)
		add_child(btn, Game.forceReadableNames)

func _enter_tree():
	EventEmitter.AddListener('selectEntity', self, _on_select_entity)

func _exit_tree():
	EventEmitter.RemoveListener('selectEntity', self, _on_select_entity)

func _on_select_entity(_node: Node, inventory: Variant) -> void:
	setupInventory(inventory.inventory if inventory else [])

func _resetButton(btn: Button):
	if (btn.has_method('_exit_tree')): btn._exit_tree()
	btn.icon = dummyButtonTexture
	btn.tooltip_text = ''
	btn.set_script(null)

func _setBuildinButton(btn: Button, config: Dictionary):
	btn.icon = load(str(Game.buildingsFolder, config.building, '/SPIcon.png'))
	btn.tooltip_text = str('Build ', config.building)
	btn.set_script(buildButtonScript)
	btn.buildingScene = load(str(Game.buildingsFolder, config.building, '/Building.tscn'))
	if (btn.has_method('_enter_tree')): btn._enter_tree()
