extends Node

class_name HelpInitializer

static func addAndReturnChild(
	node: Node,
	child: Node,
	properties: Dictionary = {}
) -> Node:
	for key in properties:
		child[key] = properties[key]

	node.add_child(child, Game.forceReadableNames)
	return child
