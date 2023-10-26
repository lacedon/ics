extends Node

signal resourceUpdated(resourceName: String, newValue: int, oldValue: int)

var resources = {
	tree = 0,
	gold = 250,
}

func changeResource(resourceName: String, change: int) -> void:
	if (resourceName in resources):
		var oldValue = resources[resourceName]
		resources[resourceName] += change
		_resourceUpdated(resourceName, resources[resourceName], oldValue)

func canUseResources(resourcesToUse: Dictionary) -> bool:
	for resourceName in resourcesToUse.keys():
		if (resourceName in resources):
			if (resources[resourceName] < resourcesToUse[resourceName]):
				return false
		else:
			return false
	return true

func useResources(resourcesToUse: Dictionary) -> void:
	prints('Using resources:', resourcesToUse)
	for resourceName in resourcesToUse.keys():
		changeResource(resourceName, -resourcesToUse[resourceName])

func _resourceUpdated(resourceName: String, newValue: int, oldValue: int) -> void:
	emit_signal('resourceUpdated', resourceName, newValue, oldValue)

func _enter_tree():
	EventEmitter.AddEmitter('resourceUpdated', self)

func _exit_tree():
	EventEmitter.RemoveEmitter('resourceUpdated', self)
