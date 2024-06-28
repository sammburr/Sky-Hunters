# AUTOLOADED 'EntityManager'


extends Node


const blimp_scene = preload("res://scenes/blimp/blimp.tscn")


@onready var master : Master = get_node("/root/Master")


enum EntityType {
	Weapon
}


var blimp_instance : Blimp = null
var entities : Array[Weapon]


func _process(delta):
	for entity : Weapon in entities:
		var state : PackedByteArray = PackedByteArray([0,0,0,0,0,0,0])
		state.encode_u8(0, entity.entity_id)
		state.encode_half(1, entity.position.x)
		state.encode_half(3, entity.position.y)
		state.encode_half(5, entity.position.z)
		master.network_manager.update_entity.rpc(state)





func spawn_blimp(spawn_point : BlimpSpawnPoint):
	
	if !spawn_point:
		return
	
	blimp_instance = blimp_scene.instantiate()
	
	blimp_instance.position = spawn_point.position
	blimp_instance.rotation = spawn_point.rotation
	
	add_child(blimp_instance)
	
	Logger.log("Spawned blimp")


func despawn_blimp():
	blimp_instance.queue_free()
	blimp_instance = null


func add_entity(pos : Vector3, id : int, type : EntityType):
	match type:
		EntityType.Weapon:
			add_weapon_entity(pos, id)


func add_weapon_entity(pos : Vector3, id : int):
	var weapon : Weapon = Weapon.generate_weapon()
	
	weapon.entity_id = id
	entities.append(weapon)
	
	weapon.position = pos
	add_child(weapon)
