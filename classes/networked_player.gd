class_name NetworkedPlayer
extends Player

var last_pos : Vector3 # Let client calculate velocity

var input_dir : Vector2
var input_jump : float

@onready var name_label : Label3D = $Name

@onready var animation_tree : AnimationTree = $FISHMAN/AnimationTree

@onready var head_skeleton_ik : SkeletonIK3D = $"FISHMAN/Armature/Skeleton3D/SkeletonIK3D"
@onready var head_ik_target : Node3D = $"FISHMAN/Head IK Target"
@onready var head_looking_at : Node3D  = $"Head/Mesh 1" # This is a point in space that the head is looking at, away from the head

func _ready():
	name_label.text = name
	head_skeleton_ik.start()
	last_pos = position

func _physics_process(delta):
	
	# Update head IK - needs to be done on both server and client
	head_ik_target.global_position = head_looking_at.global_position
	
	if not multiplayer.is_server():
		var vel = position - last_pos
		# Update aniamtion tree (client)
		animation_tree.set("parameters/Walking/blend_position", vel.length() * 72 / 5.0)
	
		last_pos = lerp(last_pos, position, 0.5)

	else:
		# Update animation tree (server)
		animation_tree.set("parameters/Walking/blend_position", velocity.length() / 5.0)
		
		apply_gravity()
		if input_jump and is_on_floor():
			player_jump()

		player_move(input_dir)
