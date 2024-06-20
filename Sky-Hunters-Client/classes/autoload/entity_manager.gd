# AUTOLOADED 'EntityManager'


extends Node


const blimp_scene = preload("res://scenes/blimp/blimp.tscn")


var blimp_instance : Blimp = null


func spawn_blimp(pos : Vector3, rot : float):
	blimp_instance = blimp_scene.instantiate()
	
	blimp_instance.position = pos
	blimp_instance.rotation.y = rot
	
	add_child(blimp_instance)


func despawn_blimp():
	blimp_instance.queue_free()
	blimp_instance = null
