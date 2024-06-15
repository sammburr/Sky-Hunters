class_name Player
extends CharacterBody3D

var jump = 3.0
var speed = 5
var ground_dist = 0.12

@onready var head : Node3D = $Head
@onready var ground_check : RayCast3D = $"Ground Check"

var is_grounded : bool = false

func _ready():
	ground_check.target_position = Vector3(0, -ground_dist, 0)

func apply_gravity():
	if ground_check.is_colliding():
		is_grounded = true
	else:
		is_grounded = false
	
	if not is_grounded:
		velocity.y -= 9.81 * get_physics_process_delta_time()

func player_jump():
	velocity.y += jump

func player_move(input_dir : Vector2):
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	velocity.z = lerp(velocity.z, 0.0, 0.5)
	velocity.x = lerp(velocity.x, 0.0, 0.5)
	
	move_and_slide()
