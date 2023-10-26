extends Node

class_name WithSelectEntityHandler

var isSelected: bool = false
var _outlineMaterial: Shader = preload('res://shaders/outline.gdshader')

func _enter_tree():
	EventEmitter.AddListener('selectEntity', self, _on_select_entity)

func _exit_tree():
	EventEmitter.RemoveListener('selectEntity', self, _on_select_entity)

func _on_select_entity(node: Node, _inventoryData: Variant) -> void:
	var parent = get_parent()
	isSelected = !isSelected if parent == node else false

	if (isSelected):
		var outlineShaderMaterial: ShaderMaterial = ShaderMaterial.new()
		outlineShaderMaterial.shader = _outlineMaterial
		parent.sprite.material = outlineShaderMaterial
	else:
		parent.sprite.material = null
