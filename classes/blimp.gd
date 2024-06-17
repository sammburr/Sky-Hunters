class_name Blimp
extends CharacterBody3D

@export var speed_control : SpeedController
@export var steer_control : SteerController

var target_rotation_y : float

func _process(delta):
	if multiplayer.is_server():
		reflect_blimp_pos_rot.rpc(position, rotation.y)
	
	velocity = transform.basis.inverse() * Vector3(0.0, 0.0, speed_control.value)
	target_rotation_y = steer_control.value
	target_rotation_y = clamp(target_rotation_y, -2.0, 2.0)

	if velocity:
		rotation.y += target_rotation_y * 0.01
		
	print(rotation.y)

	move_and_slide()

@rpc("authority", "call_remote", "unreliable")
func reflect_blimp_pos_rot(pos : Vector3, rot : float):
	position = pos
	rotation.y = rot
