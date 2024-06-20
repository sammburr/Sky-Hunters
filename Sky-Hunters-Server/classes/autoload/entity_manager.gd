# AUTOLOADED 'EntityManager'


extends Node


const blimp_scene = preload("res://scenes/blimp/blimp.tscn")


var blimp_instance : Blimp = null


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
