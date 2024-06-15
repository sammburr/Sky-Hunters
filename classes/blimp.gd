class_name Blimp
extends CharacterBody3D

@export var speed_control : SpeedController

func _process(delta):
	velocity = transform.basis.inverse() * Vector3(0.0, 0.0, speed_control.value)

	move_and_slide()
