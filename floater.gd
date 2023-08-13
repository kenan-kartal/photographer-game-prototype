class_name Floater extends Node3D

@export var amplitude : float = 1.0
@export var frequency : float = 1.0

var _parent : Node3D = null
var _phase : float = 0.0
var _prev_offset : float = 0.0

func _ready():
	_parent = get_parent_node_3d()
	assert(_parent)

func _process(delta):
	_phase += delta * 2.0 * PI * frequency
	var new_offset := sin(_phase) * amplitude
	var parent_offset := Vector3(0.0, new_offset - _prev_offset, 0.0)
	_parent.translate(parent_offset)
	_prev_offset = new_offset
