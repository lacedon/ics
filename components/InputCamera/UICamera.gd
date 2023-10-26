extends Camera2D

var _targetZoom: = 1.75
@export var zoomRate: = 8.0
@export var zoomStep: = 0.25
@export var minZoom: = 1.0
@export var maxZoom: = 3.0

func zoomIn() -> void:
	_targetZoom = max(minZoom, _targetZoom - zoomStep)
	set_physics_process(true)

func zoomOut() -> void:
	_targetZoom = min(maxZoom, _targetZoom + zoomStep)
	set_physics_process(true)

func _physics_process(delta):
	zoom = lerp(
		zoom,
		_targetZoom * Vector2.ONE,
		zoomRate * delta
	)
	if (zoom.x == _targetZoom):
		set_physics_process(false)

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		if (event.button_mask == MOUSE_BUTTON_MASK_RIGHT):
			position -= event.relative * zoom
	elif (event is InputEventMouseButton):
		if (event.is_pressed()):
			match (event.button_index):
				MOUSE_BUTTON_WHEEL_UP: zoomOut()
				MOUSE_BUTTON_WHEEL_DOWN: zoomIn()
