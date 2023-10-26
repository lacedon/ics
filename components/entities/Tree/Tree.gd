@icon('./icon.svg')
extends Node2D
class_name GameTree

signal selectEntity(node: Node2D, inventory: Dictionary)
signal clickOnTree(node: Node2D)

@export var sprite: Sprite2D
@export var entityCollision: Area2D
@export var health: int:
	get: return WithValue.passGetValue(withHealth)
	set(value): WithValue.passSetValue(withHealth, value)
@export var maxHealth: int:
	get: return WithValue.passGetMaxValue(withHealth)
	set(value): WithValue.passSetMaxValue(withHealth, value)

@onready var withHealth: WithValue = HelpInitializer.addAndReturnChild(self, WithValue.new())
@onready var withClickCollision: WithClickCollision = HelpInitializer.addAndReturnChild(self, WithClickCollision.new())
@onready var withDebugger: WithDebugger = HelpInitializer.addAndReturnChild(self, WithDebugger.new())

func _ready():
	withDebugger.position = Vector2(
		-withDebugger.size.x / 2,
		-sprite.get_rect().size.y / 2 + withDebugger.size.y,
	)

func _enter_tree():
	if (withClickCollision && !withClickCollision.is_connected('input_event', _on_withClickCollision_click)):
		withClickCollision.connect('click', _on_withClickCollision_click)
	EventEmitter.AddEmitter('selectEntity', self)
	EventEmitter.AddEmitter('clickOnTree', self)

func _exit_tree():
	withClickCollision.disconnect('click', _on_withClickCollision_click)
	EventEmitter.RemoveEmitter('selectEntity', self)
	EventEmitter.RemoveEmitter('clickOnTree', self)

func _on_withClickCollision_click(buttonIndex: int):
	if (buttonIndex == MOUSE_BUTTON_MASK_LEFT):
		emit_signal('selectEntity', self, {})
		emit_signal('clickOnTree', self)
