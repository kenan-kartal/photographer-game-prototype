class_name Character extends CharacterBody3D

@export var speed : float = 5.0

var _gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

var _target_node : Node3D = null
var _target_global_position : Vector3
var _tolerance : float = 0.1
var _move_state : MovementState = MovementState.Idle

## Emitted when character reaches target.
signal target_reached()

enum MovementState {
	Idle,
	GoToNode,
	GoToPosition
}

func _on_target_reached():
	_move_state = MovementState.Idle
	target_reached.emit()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= _gravity * delta
	if _move_state == MovementState.Idle:
		velocity.x = 0.0
		velocity.z = 0.0
	else:
		if _move_state == MovementState.GoToNode:
			_target_global_position = _target_node.global_position
		var dir := _target_global_position - global_position
		dir.y = 0.0
		var len := dir.length() 
		if len <= _tolerance:
			_on_target_reached()
		else:
			dir /= len
			dir *= speed
			dir = transform.basis * dir
		velocity.x = dir.x
		velocity.z = dir.z
	move_and_slide()

func go_to_target_node(target: Node3D, tolerance: float = 0.1):
	_target_node = target
	_tolerance = tolerance
	_move_state = MovementState.GoToNode

func go_to_target_global_position(target: Vector3, tolerance: float = 0.1):
	_target_global_position = target
	_tolerance = tolerance
	_move_state = MovementState.GoToPosition
