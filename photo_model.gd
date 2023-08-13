class_name PhotoModel extends Node3D

var _rotate_speed : float = 5.0
var _spin := false

func _process(delta):
	if not _spin:
		return
	var rotate_amount : float = delta * _rotate_speed
	rotate_y(rotate_amount)

func set_spin(val: bool):
	_spin = val
