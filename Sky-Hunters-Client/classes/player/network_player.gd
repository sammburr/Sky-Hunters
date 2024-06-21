class_name NetworkPlayer
extends Node3D


@onready var head : Node3D = $Head
@onready var head_ik : SkeletonIK3D = $FISHMAN/Armature/Skeleton3D/SkeletonIK3D
@onready var head_ik_target : NodePath = NodePath("../../../../Head/MeshInstance3D")

func _ready():
	head_ik.target_node = head_ik_target
	head_ik.start()

func move_player(pos : Vector3, head_rot : float, player_rot : float):
	global_position = pos
	head.rotation.x = head_rot
	rotation.y = player_rot
