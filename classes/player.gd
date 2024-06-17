class_name Player
extends CharacterBody3D

var jump = 3.0
var speed = 13
var ground_dist = 0.12

@onready var head : Node3D = $Head
@onready var ground_check : RayCast3D = $"Ground Check"
@onready var look_ray_cast : RayCast3D = $Head/Look

var is_grounded : bool = false

enum InputType {
	REG,		# No input target, just walking around
	ONEDIM_WS,  # Has an input target and listen to W and S keys
	ONEDIM_AD   # || listen to A and D keys
}

var current_input_type := InputType.REG
var input_target : PWInterface

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
	if current_input_type != InputType.REG:
		match current_input_type:
			
			InputType.ONEDIM_WS:
				pw_interact_1d(input_dir.y)
			InputType.ONEDIM_AD:
				pw_interact_1d(input_dir.x)
		return
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	velocity.z = lerp(velocity.z, 0.0, 0.5)
	velocity.x = lerp(velocity.x, 0.0, 0.5)
	
	move_and_slide()

# Check if player is looking at something to interact with
# returns the node to interact with
func can_interact():
	if look_ray_cast.is_colliding() && look_ray_cast.get_collider() is PWInterface:
		input_target = look_ray_cast.get_collider()
		return true
	return false

func interact():
	if current_input_type != InputType.REG: # Meaning there is already an input target 'locked'
		current_input_type = InputType.REG  # Switch back to regural input, not talking to an input target
		return
	
	if can_interact():
		current_input_type = input_target.input_type

func pw_interact_1d(val : float):
	if val < 0:
		input_target.increase_value()
	elif val > 0:
		input_target.decrease_value()
