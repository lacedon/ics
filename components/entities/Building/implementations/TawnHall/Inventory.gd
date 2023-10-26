extends Node

const data: Dictionary = {
	name = 'Town Hall',
	inventory = [
		{ type = 'building', building = "Farm" },
		{ type = 'space' },
		{ type = 'building', building = "Castle" },
	]
};

func getInventory():
	return data
