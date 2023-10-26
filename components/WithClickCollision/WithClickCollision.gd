extends Area2D

class_name WithClickCollision

signal click(button_index: int)

## Use sprite to generate CollisionPolygon2D
@export var sprite: Sprite2D
## Use predefined CollisionShape2D instead of generating it
@export var clickCollisionShape: CollisionShape2D
## Use predefined CollisionPolygon2D instead of generating it
@export var clickCollisionPolygon: CollisionPolygon2D
@export var shouldRemoveOriginalCollision: bool = true
var _lastEventFrame: int

func _createCollisionPolygonFromSprite(sp: Sprite2D):
	if (!sp || !sp.texture):
		prints('Cannot create clicking collision polygon for', self, 'since there\'s no sprite')
		return

	var bm = BitMap.new()
	bm.create_from_image_alpha(sp.texture.get_image())

	var polygon = Polygon2D.new()
	polygon.set_polygons(bm.opaque_to_polygons(sp.region_rect))

	var collisionPolygon = CollisionPolygon2D.new()
	collisionPolygon.set_polygon(polygon.polygons[0])

	add_child(collisionPolygon, Game.forceReadableNames)
	position = sp.position - (sp.region_rect.position + sp.region_rect.size) / 2

func _joinCollision(collisionNode, shouldMoveNode: bool) -> void:
	if (shouldMoveNode):
		var collisionNodeParent = collisionNode.get_parent()
		if (collisionNodeParent): collisionNodeParent.remove_child(collisionNode)
	add_child(collisionNode)

func _enter_tree():
	assert(
		sprite || clickCollisionShape || clickCollisionPolygon,
		'Cannot use WithClickCollision without spritem collisionShape, or collisionPolygon'
	)

	if (sprite): _createCollisionPolygonFromSprite(sprite)
	elif (clickCollisionShape): _joinCollision(clickCollisionShape, shouldRemoveOriginalCollision)
	elif (clickCollisionPolygon): _joinCollision(clickCollisionPolygon, shouldRemoveOriginalCollision)

	monitoring = false
	monitorable = false
	input_pickable = true
	collision_mask = 0
	collision_layer = 2
	connect('input_event', _on_input_event)

func _exit_tree():
	disconnect('input_event', _on_input_event)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if (
		event is InputEventMouseButton &&
		!event.is_pressed()
	):
		var frame = get_tree().get_frame()
		# Avoid situation with trigering handler twice for one event
		if (_lastEventFrame == frame): return

		_lastEventFrame = frame
		emit_signal('click', event.button_index)
