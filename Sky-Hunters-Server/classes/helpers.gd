class_name Helpers
extends Node


# Given a byte (int between 0 and 255) returns
# the binary representation as a String
static func byte_as_binary(byte : int) -> String:
	var string := ""
	for i in range(7, -1, -1):
		if (byte & (1 << i)) != 0:
			string += "1"
		else:
			string += "0"
	return string


static func pack_b8(bools : Array) -> int:
	var packed_byte: int = 0
	
	# Ensure only the first 8 boolean values are considered
	var num_bools_to_pack: int = min(bools.size(), 8)
	
	for i in range(num_bools_to_pack):
		if bools[i]:
			packed_byte |= (1 << i)
	
	return packed_byte


static func unpack_b8(byte : int) -> Array:
	var bools : Array = []
	
	for i in range(8):
		var bit_value: bool = (byte & (1 << i)) != 0
		bools.append(bit_value)
	
	return bools


static func split_b16(value : int) -> Array:
	
	var value_abs = abs(value)
	
	var byte1: int = (value_abs >> 8) & 0xFF
	var byte2: int = value_abs & 0xFF
	
	if value > 0:
		byte1 = byte1 | 0x80
	
	return [byte1, byte2]
