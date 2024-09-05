extends AnimatableBody3D


@export var destination: Vector3
@export var duration: float = 3
@export var wait_time: float = 0
@export var loop: bool = true

func _ready() -> void:
	var tween = create_tween()
	if loop == true:
		tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_interval(wait_time)
	tween.tween_property(self, "global_position", global_position, duration)
	tween.tween_interval(wait_time)
