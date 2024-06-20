class_name VehicalControl
extends StaticBody3D


enum ControlInputType {
	FORWARD_BACKWARD,
	LEFT_RIGHT
}


var value : float
@export var min_value : float
@export var max_value : float
@export var increment : float
@export var input_type : ControlInputType
@export var stand_target : Node3D


func read_input(input_map : PackedByteArray):
	var unpacked_input_map : Array = Helpers.unpack_b8(input_map[0])

	match input_type:
		
		ControlInputType.FORWARD_BACKWARD:
			var forward = int(unpacked_input_map[0])
			var back = int(unpacked_input_map[1])
			
			update_value((forward - back) * increment)
			
		ControlInputType.LEFT_RIGHT:
			var left = int(unpacked_input_map[2])
			var right = int(unpacked_input_map[3])
			
			update_value((left - right) * increment)


func update_value(by : float):
	value += by
	value = clamp(value, min_value, max_value)
