class_name Character extends CharacterBody3D

@export var speed : float = 5.0
@export var yaw_limit := Vector2(-70, 70)
@export var pitch_limit := Vector2(-30, 40)

@onready var cam := $CameraGroup/Yaw/Pitch/Camera3D

@onready var _cam_yaw := $CameraGroup/Yaw
@onready var _cam_pitch := $CameraGroup/Yaw/Pitch

var camera_mode : bool = false:
	get:
		return camera_mode
	set(value):
		if value != camera_mode:
			camera_mode = value
			_update_mode()

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

func _update_mode():
	$CamBorder.visible = camera_mode

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= _gravity * delta
	if _move_state == MovementState.Idle:
		velocity.x = 0.0
		velocity.z = 0.0
	else:
		if _move_state == MovementState.GoToNode:
			_target_global_position = _target_node.global_position
		var diff := _target_global_position - global_position
		diff.y = 0.0
		var length := diff.length()
		if length <= _tolerance:
			_on_target_reached()
			velocity.x = 0.0
			velocity.z = 0.0
		else:
			look_at(global_position + diff)
			var forward := transform.basis.z
			forward *= speed
			velocity.z = -forward.z
			velocity.x = -forward.x
	move_and_slide()

func go_to_target_node(target: Node3D, tolerance: float = 0.1):
	_target_node = target
	_tolerance = tolerance
	_move_state = MovementState.GoToNode

func go_to_target_global_position(target: Vector3, tolerance: float = 0.1):
	_target_global_position = target
	_tolerance = tolerance
	_move_state = MovementState.GoToPosition

func stop():
	_move_state = MovementState.Idle

## Rotate the camera horizontally (rot.x) and vertically (rot.y) in given euler angles.
func rotate_cam(rot: Vector2):
	var yaw : float = _cam_yaw.rotation_degrees.y
	yaw += rot.x
	yaw = clampf(yaw, yaw_limit.x, yaw_limit.y)
	var pitch : float = _cam_pitch.rotation_degrees.x
	pitch += rot.y
	pitch = clampf(pitch, pitch_limit.x, pitch_limit.y)
	_cam_yaw.rotation_degrees.y = yaw
	_cam_pitch.rotation_degrees.x = pitch
