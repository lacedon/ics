@icon('./icon.svg')
extends Node2D
class_name Building

signal selectEntity(node: Node2D, inventory: Variant)
signal clickOnBuilding(node: Node2D)

const healthBarScene: PackedScene = preload('res://ui/HealthBar/UIHealthBar.tscn')

@export var sprite: Sprite2D
@export var entityCollision: Area2D
@export_enum("statePlacing", "stateBuilding", "stateReady") var presetState: String = "statePlacing"
@export var _inventoryFile: GDScript
@export var health: int:
	get: return WithValue.passGetValue(self.withHealth)
	set(value): WithValue.passSetValue(self.withHealth, value)
@export var maxHealth: int:
	get: return WithValue.passGetMaxValue(self.withHealth)
	set(value): WithValue.passSetMaxValue(self.withHealth, value)

@onready var inventory: Dictionary = _inventoryFile.new().getInventory() if _inventoryFile else {}
@onready var timer: Timer = HelpInitializer.addAndReturnChild(self, Timer.new())
@onready var healthBar: Range = HelpInitializer.addAndReturnChild(self, healthBarScene.instantiate())
@onready var withHealth: WithValue = HelpInitializer.addAndReturnChild(self, WithValue.new(), { healthBar = healthBar })
@onready var withClickCollision: WithClickCollision = HelpInitializer.addAndReturnChild(self, WithClickCollision.new(), { sprite = sprite })
@onready var withSelectEntityHandler: WithSelectEntityHandler = HelpInitializer.addAndReturnChild(self, WithSelectEntityHandler.new())
@onready var withDebugger: WithDebugger = HelpInitializer.addAndReturnChild(self, WithDebugger.new())
@onready var statePlacing: State = HelpInitializer.addAndReturnChild(self, BuildingStatePlacing.new())
@onready var stateBuilding: State = HelpInitializer.addAndReturnChild(self, BuildingStateBuilding.new())
@onready var stateReady: State = HelpInitializer.addAndReturnChild(self, BuildingStateReady.new())
@onready var withStateMachine: WithStateMachine = HelpInitializer.addAndReturnChild(self, WithStateMachine.new(), { state = self[presetState] })

func startPlacing() -> void:
	await self.ready
	withStateMachine.changeState(statePlacing)

func build() -> void:
	withStateMachine.changeState(stateBuilding)

func canBeBuild() -> bool:
	return withStateMachine.state == statePlacing && statePlacing.canBeBuild()

func _ready():
	healthBar.position = Vector2(
		-healthBar.size.x / 2,
		sprite.get_rect().size.y / 2 - healthBar.size.y,
	)
	withDebugger.position = Vector2(
		-withDebugger.size.x / 2,
		-sprite.get_rect().size.y / 2 + withDebugger.size.y,
	)
	if (!withClickCollision.is_connected('click', _on_withClickCollision_click)):
		withClickCollision.connect('click', _on_withClickCollision_click)

func _enter_tree():
	if (withClickCollision && !withClickCollision.is_connected('input_event', _on_withClickCollision_click)):
		withClickCollision.connect('click', _on_withClickCollision_click)
	EventEmitter.AddEmitter('selectEntity', self)
	EventEmitter.AddEmitter('clickOnBuilding', self)

func _exit_tree():
	withClickCollision.disconnect('click', _on_withClickCollision_click)
	EventEmitter.RemoveEmitter('selectEntity', self)
	EventEmitter.RemoveEmitter('clickOnBuilding', self)

func _on_withClickCollision_click(buttonIndex: int):
	if (buttonIndex == MOUSE_BUTTON_MASK_LEFT):
		if (withStateMachine.state != statePlacing):
			emit_signal('selectEntity', self, inventory if withStateMachine.state == stateReady else {})
		emit_signal('clickOnBuilding', self)
