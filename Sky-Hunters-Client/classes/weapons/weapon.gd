class_name Weapon
extends Node3D


var current_body_inst : WeaponBody


func fire_weapon():
	current_body_inst.fire_weapon()


func reload_weapon():
	current_body_inst.reload_weapon()


static func create_weapon(stock : PartInfo, body : PartInfo, barrel : PartInfo) -> Weapon:
	var weapon : Weapon = Weapon.new()
	var body_inst : WeaponBody = body.scene.instantiate()
	
	weapon.current_body_inst = body_inst
	body_inst.add_parts(stock, barrel)
	
	weapon.add_child(body_inst)
	
	return weapon
