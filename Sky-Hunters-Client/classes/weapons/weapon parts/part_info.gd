class_name PartInfo
extends Resource


enum PartType {
	STOCK,
	BODY,
	BARREL
}


@export var part_name : String
@export var part_type : PartType
@export var scene : PackedScene
@export var number_barrels : int
