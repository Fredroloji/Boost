class_name Camera_Position_target extends Node3D

var target: Node3D 
var offset: Vector3

func _ready() -> void:
	target = get_parent_node_3d()
	offset = position
 

func _process(delta: float) -> void:
	global_position = target.global_position + offset
