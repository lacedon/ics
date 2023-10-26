extends Button

signal startPlacingBuilding(building, source)

@export var buildingScene: PackedScene

func _enter_tree():
	connect("button_up",Callable(self,'_on_Button_button_up'))
	EventEmitter.AddEmitter('startPlacingBuilding', self)

func _exit_tree():
	disconnect("button_up",Callable(self,'_on_Button_button_up'))
	EventEmitter.RemoveEmitter('startPlacingBuilding', self)

func emitStartPlacingBuilding():
	emit_signal('startPlacingBuilding', buildingScene, self.name)

func _on_Button_button_up():
	emitStartPlacingBuilding()
