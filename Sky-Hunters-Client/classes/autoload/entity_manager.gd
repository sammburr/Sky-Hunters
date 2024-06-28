# AUTOLOADED 'EntityManager'


extends Node


const blimp_scene = preload("res://scenes/blimp/blimp.tscn")


enum EntityType {
	Weapon
}


var blimp_instance : Blimp = null
var entities : Array[Node3D]


func spawn_blimp(pos : Vector3, rot : float):
	blimp_instance = blimp_scene.instantiate()
	
	blimp_instance.position = pos
	blimp_instance.rotation.y = rot
	
	add_child(blimp_instance)


func despawn_blimp():
	blimp_instance.queue_free()
	blimp_instance = null


func add_entity(id : int, type : EntityType, config : Dictionary):
	match type:
		EntityType.Weapon:
			add_weapon_entity(id, config)
			

func add_weapon_entity(id : int, config : Dictionary): 
	var weapon : Weapon = Weapon.create_weapon(config["stock"], config["body"], config["barrel"])
	weapon.name = str(id)
	weapon.scale = Vector3.ONE * 0.04
	
	entities.append(weapon)
	add_child(weapon)
