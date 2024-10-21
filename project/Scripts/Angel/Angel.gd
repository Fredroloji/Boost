extends Node3D

var rng = RandomNumberGenerator.new()



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



"""
var direction: int = 1
# all thse vars should be random
var speed: float = 100
var x_limit: float = 50
func _process(delta: float) -> void:
	
	position += Vector3(direction, 0 ,0) * speed * delta
	
	if position.x == x_limit:
		print("my x is: ", position.x)
		#direction = -1
"""

"""
func _process(delta: float) -> void:
	var rand_x = rng.randf_range(10.0, 30.0)
	var rand_y = rng.randf_range(10.0, 30.0)
	var wait = rng.randf_range(1.0, 5.0)
	var duration = rng.randf_range(2.0, 5.0)
	
	var destination: Vector3
	destination = Vector3(rand_x, rand_y, 0)
	
	var tween = create_tween()
	

	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", destination, duration)
#	tween.create_timer(wait).timeout
#	SceneTree.create_timer(wait, true, false, false).timeout
	
	print("Rand X:", rand_x)
	print("Rand Y:", rand_y)
	print("Wait  :", wait)
	print("Duratn:", duration, "\n")


func _ready() -> void:
	pass
"""

