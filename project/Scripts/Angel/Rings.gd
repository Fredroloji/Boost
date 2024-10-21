extends GPUParticles3D

@export var x_rotate: int = 1 
@export var y_rotate: int = 1 
@export var z_rotate: int = 1 

@export var speed: float = 0.003

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(Vector3(x_rotate, 0, 0), speed)
	rotate(Vector3(0, y_rotate, 0), speed)
	rotate(Vector3(0, 0, z_rotate), speed)
