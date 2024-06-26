# AUTOLOADED 'LevelManager'


extends Node


const levels_path = "res://scenes/levels/"

const test_level : LevelInfo = preload(levels_path + "test_level.tres")
# const new_level : LevelInfo = preload(levels_path + "new_level.tres")

var levels = {
	"TestLevel" : "test_level.tscn"
  # "NewLevel"  : "new_level.tscn"
}

var current_level : Node3D
var blimp_spawn_point : BlimpSpawnPoint
var weapon_spawn_points : Array[WeaponSpawnPoint]


func load_level(info : LevelInfo):
	Logger.log("Loading level: " + info.name + "...")
	
	for level_name in levels.keys():
		if level_name == info.name:			
			var level : PackedScene = load(levels_path + levels[level_name])
			current_level = level.instantiate()
			add_child(current_level)
			
			# Look for the blimp spawn point
			for child in current_level.get_children():
				if child is BlimpSpawnPoint:
					blimp_spawn_point = child
				elif child is WeaponSpawnPoint:
					weapon_spawn_points.append(child)
			
			Logger.log("Loaded level: " + info.name)
