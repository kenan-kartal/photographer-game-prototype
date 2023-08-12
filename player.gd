class_name Player extends Node3D

const CAMERA_SPEED_BASE_PIXEL_COUNT : int = 100

# Calculated as Euler angle change per CAMERA_SPEED_BASE_PIXEL_COUNT.
@export var camera_speed : Vector2 = Vector2(100.0, 80.0)

var _primary_mouse_button_down : bool = false
var _secondary_mouse_button_down : bool = false

func _handle_input_mouse_motion(event: InputEventMouseMotion):
	push_warning("Not implemented")

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
	push_warning("Not implemented")

func _on_secondary_mouse_button_clicked():
	push_warning("Not implemented")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_handle_input_mouse_motion(event)
	elif event is InputEventMouseButton:
		_handle_input_mouse_button(event)
