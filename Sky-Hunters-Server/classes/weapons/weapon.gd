class_name Weapon
extends Node3D


enum Stocks {
	SHORT,
	SHOULDER
}

enum Bodies {
	BOLT,
	BREAK,
	GATTLING
}

enum Barrels {
	SINGLE,
	DOUBLE
}


@export var entity_id : int
@export var stock : Stocks
@export var body : Bodies
@export var barrel : Barrels


static func generate_weapon() -> Weapon:
	var weapon : Weapon = Weapon.new()
	
	weapon.stock = Stocks.values().pick_random()
	weapon.body = Bodies.values().pick_random()
	weapon.barrel = Barrels.values().pick_random()
	
	return weapon
	
