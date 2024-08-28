extends RigidBody3D

#vars
#var player_vector: Vecort3 = Vector3(0, 0, 0)
@export var thrust: int = 3000
@export var brake: int = 2500
# 14600 on damp 3 for no spinning
@export var turnSpeed: int = 500
var is_boosting: bool = false
var boost: float = 500

# stops the win and crash commands from executing multiple times
var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $Audio/Explosion_Audio
@onready var win_audio: AudioStreamPlayer = $Audio/Win_Audio
@onready var engine_audio: AudioStreamPlayer3D = $Audio/Engine_Audio
@onready var boost_particle: GPUParticles3D = $Rocket_Boost
@onready var left_particle: GPUParticles3D = $Rocket_Boost_Left
@onready var right_particle: GPUParticles3D = $Rocket_Boost_Right
@onready var explode_particle: GPUParticles3D = $Explode
@onready var anti_gravity_particle: GPUParticles3D = $Anti_Gravity_Particle

# movement code
func _process(delta: float) -> void:
	# accelerate
	if Input.is_action_pressed("thrust"):
		apply_central_force(basis.y * delta * thrust)
		boost_particle.emitting = true
		if engine_audio.playing == false:
			engine_audio.play()
	else:
		engine_audio.stop()
		boost_particle.emitting = false
	
	if Input.is_action_pressed("brake"):
		apply_central_force(-basis.y * delta * brake)
		if engine_audio.playing == false:
			engine_audio.play()
	else:
		engine_audio.stop()
	
	# turn left
	if Input.is_action_pressed("turn_left"):
		apply_torque(Vector3(0, 0, -turnSpeed * delta))
		right_particle.emitting = true
	else:
		right_particle.emitting = false

	# turn right
	if Input.is_action_pressed("turn_right"):
		apply_torque(Vector3(0, 0, turnSpeed * delta))
		left_particle.emitting = true
	else:
		left_particle.emitting = false

	#if Input.is_action_pressed("boost"):
	#	is_boosting = true
	#	if is_boosting == true: 
	#		thrust += boost
	#		is_boosting = false

	if Input.is_action_just_pressed("anti-gravity"):
		gravity_scale = -gravity_scale
		var changed_gravity: bool = false
		anti_gravity_particle.emitting = true
		if changed_gravity == true:
			changed_gravity = false
			anti_gravity_particle.emitting = false
		else:
			changed_gravity = true
			anti_gravity_particle.emitting = true

# collision
func _collision(body: Node) -> void:
	# prints what colliding with
	# print(body.name)
	if is_transitioning == false:
		if "goal" in body.get_groups():
			win(body.file_path)
		
		if "danger" in body.get_groups():
			crash()

# winning conditions
func win(next_level_file: String) -> void:
	print("you win!")
	win_audio.play()
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))

# losing conditions
func crash() -> void:
	print("BOOM")
	explode_particle.emitting = true
	boost_particle.emitting = false
	right_particle.emitting = false
	left_particle.emitting = false
	engine_audio.stop()
	explosion_audio.play()
	gravity_scale *= 10
	apply_central_force(basis.y * 10000)
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2)
	tween.tween_callback(get_tree().reload_current_scene)
