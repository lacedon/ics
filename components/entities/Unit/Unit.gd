@icon('./icon.svg')
extends Node2D
class_name Unit

signal selectEntity(node: Node2D, inventory: Variant)
signal clickOnBuilding(node: Node2D)

const healthBarScene: PackedScene = preload('res://ui/HealthBar/UIHealthBar.tscn')

@export var animatedSprite: AnimatedSprite2D
@export var entityCollision: Area2D
@export var clickShape: CollisionShape2D
@export var clickPolygon: CollisionPolygon2D
@export var health: int:
	get: return WithValue.passGetValue(withHealth)
	set(value): WithValue.passSetValue(withHealth, value)
@export var maxHealth: int:
	get: return WithValue.passGetMaxValue(withHealth)
	set(value): WithValue.passSetMaxValue(withHealth, value)
@export_enum("stateIdle") var presetState: String = "stateIdle"

@onready var healthBar: Range = HelpInitializer.addAndReturnChild(self, healthBarScene.instantiate())
@onready var withHealth: WithValue = HelpInitializer.addAndReturnChild(self, WithValue.new(), { healthBar = healthBar })
@onready var withDebugger: WithDebugger = HelpInitializer.addAndReturnChild(self, WithDebugger.new())
@onready var stateIdle: State = HelpInitializer.addAndReturnChild(self, UnitStateIdle.new())
@onready var withStateMachine: WithStateMachine = HelpInitializer.addAndReturnChild(self, WithStateMachine.new(), { state = self[presetState] })
@onready var withClickCollision: WithClickCollision = HelpInitializer.addAndReturnChild(self, WithClickCollision.new(), {
	clickCollisionShape = clickShape,
	clickCollisionPolygon = clickPolygon,
})

func _ready():
	healthBar.position = Vector2(
		-healthBar.size.x / 2,
		animatedSprite.get_rect().size.y / 2 - healthBar.size.y,
	)
	withDebugger.position = Vector2(
		-withDebugger.size.x / 2,
		-animatedSprite.get_rect().size.y / 2 + withDebugger.size.y,
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
		emit_signal('selectEntity', self, {})
		emit_signal('clickOnBuilding', self)
