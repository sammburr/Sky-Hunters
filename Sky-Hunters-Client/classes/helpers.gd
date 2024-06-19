class_name Helpers
extends Node


# Given a byte (int between 0 and 255) returns
# the binary representation as a String
static func byte_as_binary(byte : int) -> String:
	byte = clamp(byte, 0, 255)
	
	var string := ""
	for i in range(7, -1, -1):
		if (byte & (1 << i)) != 0:
			string += "1"
		else:
			string += "0"
	return string


# Given two bytes, byte_a is 'high' and byte_b is 'low'
# returns a single concatonated 16bit value
static func b16_from_b8(byte_a : int, byte_b : int) -> int:
	byte_a = clamp(byte_a, 0, 255)
	byte_b = clamp(byte_b, 0, 255)
	
	var unsiged = (byte_a << 7) | byte_b
	
	if (byte_a & 0x80) == 0:
		unsiged *= -1
	
	return unsiged


static func pack_b8(bools : Array) -> int:
	var packed_byte: int = 0
	
	# Ensure only the first 8 boolean values are considered
	var num_bools_to_pack: int = min(bools.size(), 8)
	
	for i in range(num_bools_to_pack):
		if bools[i]:
			packed_byte |= (1 << i)
	
	return packed_byte
