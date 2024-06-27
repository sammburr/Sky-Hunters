class_name LocalArms
extends Node3D


@export var left_ik : SkeletonIK3D
@export var right_ik : SkeletonIK3D


func start_ik(left_ik_target : NodePath, right_ik_target : NodePath):
	left_ik.target_node = left_ik_target
	left_ik.start()
	
	right_ik.target_node = right_ik_target
	right_ik.start()
