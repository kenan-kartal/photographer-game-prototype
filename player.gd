class_name Player extends Node3D

const CAMERA_SPEED_BASE_PIXEL_COUNT : int = 100

## Calculated as Euler angle change per CAMERA_SPEED_BASE_PIXEL_COUNT.
@export var camera_speed := Vector2(100.0, 80.0)
@export var character : Character = null
@export var mouse_ray_length : float = 100

@onready var cam := $Camera3D

var _primary_mouse_button_down : bool = false
var _secondary_mouse_button_down : bool = false
var _player_mode := PlayerMode.Top

enum PlayerMode {
	Top,
	Photo
}

func _handle_input_mouse_motion(event: InputEventMouseMotion):
	match _player_mode:
		PlayerMode.Photo:
			var rot := camera_speed / CAMERA_SPEED_BASE_PIXEL_COUNT * event.relative
			rot.x = -rot.x
			character.rotate_cam(rot)

func _handle_input_mouse_button(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			_primary_mouse_button_down = false
		elif not _primary_mouse_button_down:
			_primary_mouse_button_down = true
			_on_primary_mouse_button_clicked()
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		if not event.pressed:
			_secondary_mouse_button_down = false
		elif not _secondary_mouse_button_down:
			_secondary_mouse_button_down = true
			_on_secondary_mouse_button_clicked()

func _on_primary_mouse_button_clicked():
	match _player_mode:
		PlayerMode.Top:
			_move_character()
		PlayerMode.Photo:
			character.shoot()

func _on_secondary_mouse_button_clicked():
	_switch_mode()

func _on_character_ready():
	character.target_reached.connect(_on_target_reached)

func _on_target_reached():
	pass

func _move_character():
	var mouse_pos := get_viewport().get_mouse_position()
	var from : Vector3 = cam.project_ray_origin(mouse_pos)
	var to : Vector3 = from + cam.project_ray_normal(mouse_pos) * mouse_ray_length
	var space := get_world_3d().get_direct_space_state()
	var ray_query := PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_result := space.intersect_ray(ray_query)
	if raycast_result:
		var pos : Vector3 = raycast_result["position"]
		character.go_to_target_global_position(pos)

func _switch_mode():
	character.stop()
	match _player_mode:
		PlayerMode.Top:
			character.cam.current = true
			character.camera_mode = true
			_player_mode = PlayerMode.Photo
		PlayerMode.Photo:
			cam.current = true
			character.camera_mode = false
			_player_mode = PlayerMode.Top

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_handle_input_mouse_motion(event)
	elif event is InputEventMouseButton:
		_handle_input_mouse_button(event)

func _ready():
	character.ready.connect(_on_character_ready)
