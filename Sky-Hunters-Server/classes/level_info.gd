class_name LevelInfo
extends Resource


@export var name : String


func to_dict() -> Dictionary:
	var dict = {}
	dict["name"] = name
	return dict
