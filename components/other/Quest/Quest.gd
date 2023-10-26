extends Node2D

@export var sprite: Texture2D;

func _enter_tree():
	$Sprite.texture = sprite
