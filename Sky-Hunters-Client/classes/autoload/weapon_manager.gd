# AUTOLOADED 'Master'


extends Node


const short_stock : PartInfo = preload("res://classes/weapons/weapon parts/short_stock.tres")
const shoulder_stock : PartInfo = preload("res://classes/weapons/weapon parts/shoulder_stock.tres")
const bolt_action : PartInfo = preload("res://classes/weapons/weapon parts/bolt_action_body.tres")
const break_action : PartInfo = preload("res://classes/weapons/weapon parts/break_action_body.tres")
const gattling : PartInfo = preload("res://classes/weapons/weapon parts/gattling_body.tres")
const single_barrel : PartInfo = preload("res://classes/weapons/weapon parts/single_barrel.tres")
const double_barrel : PartInfo = preload("res://classes/weapons/weapon parts/double_barrel.tres")


var stocks = []
var bodies = []
var barrels = []


var local_weapon : Weapon

func _ready():
	stocks = [short_stock, shoulder_stock]
	bodies = [bolt_action, break_action, gattling]
	barrels = [single_barrel, double_barrel]




func generate_weapon():
	if local_weapon:
		local_weapon.queue_free()
	local_weapon = Weapon.create_weapon(stocks.pick_random(), bodies.pick_random(), barrels.pick_random())
	local_weapon.scale = Vector3.ONE * 0.1
	add_child(local_weapon)


func _process(delta):
	if Input.is_action_just_pressed("fire_weapon") && local_weapon:
		local_weapon.fire_weapon()
	if Input.is_key_pressed(KEY_R):
		generate_weapon()
