extends MeshInstance3D

var player_pos
@onready var player = get_parent().get_parent().get_node("Player")

func _physics_process(delta: float) -> void:
	player_pos = player.position
	look_at(player_pos)
