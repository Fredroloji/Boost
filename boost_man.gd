extends RigidBody3D

# complex stuff I want to do
# missiles
# death counter
# black holes

#vars
#var player_vector: Vecort3 = Vector3(0, 0, 0)
@export var thrust: int = 2500
@export var brake: int = 2500
@export var boost: int = 4000
# 14600 on damp 3 for no spinning
@export var turnForce: int = 1000
@export var fuel: float = 100
@export var fuel_usage: int = 1000
var max_fuel: float = fuel

# stops the win and crash commands from executing multiple times
var is_transitioning: bool = false

# audio
@onready var explosion_audio: AudioStreamPlayer = $Audio/Explosion_Audio
@onready var win_audio: AudioStreamPlayer = $Audio/Win_Audio
@onready var engine_audio: AudioStreamPlayer3D = $Audio/Engine_Audio

# particles
@onready var boost_particle: GPUParticles3D = $Rocket_Boost
@onready var thrust_particle: GPUParticles3D = $Rocket_Thrust
@onready var brake_particle: GPUParticles3D = $Rocket_Thrust_Down
@onready var left_turn_particle: GPUParticles3D = $Rocket_Thrust_Left
@onready var right_turn_particle: GPUParticles3D = $Rocket_Thrust_Right
@onready var explode_particle: GPUParticles3D = $Explode
@onready var anti_gravity_particle: GPUParticles3D = $Trail
@onready var crash_smoke_particle: GPUParticles3D = $Death_Smoke

func _ready() -> void:
	set_fuel_bar()
	$Fuel_Bar.max_value = max_fuel

func set_fuel_bar() -> void:
	$Fuel_Bar.value = fuel

# movement code
func _process(delta: float) -> void:
	# accelerate
	if Input.is_action_pressed("thrust"):
		apply_central_force(basis.y * delta * thrust)
		thrust_particle.emitting = true
		fuel -= delta * (thrust / fuel_usage)
		set_fuel_bar()
		if engine_audio.playing == false:
			engine_audio.play()
	else:
		engine_audio.stop()
		thrust_particle.emitting = false
	
	if Input.is_action_pressed("brake"):
		apply_central_force(-basis.y * delta * brake)
		brake_particle.emitting = true
		fuel -= delta * (brake / fuel_usage)
		set_fuel_bar()
		if engine_audio.playing == false:
			engine_audio.play()
	else:
		engine_audio.stop()
		brake_particle.emitting = false
	
	# turn left
	if Input.is_action_pressed("turn_left"):
		apply_torque(Vector3(0, 0, delta * -turnForce))
		apply_central_force(basis.y * delta * turnForce)
		right_turn_particle.emitting = true
		fuel -= delta * (turnForce / fuel_usage)
		set_fuel_bar()
	else:
		right_turn_particle.emitting = false

	# turn right
	if Input.is_action_pressed("turn_right"):
		apply_torque(Vector3(0, 0, delta * turnForce))
		apply_central_force(basis.y * delta * turnForce)
		left_turn_particle.emitting = true
		fuel -= delta * (turnForce / fuel_usage)
		set_fuel_bar()
	else:
		left_turn_particle.emitting = false

	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * boost)
		boost_particle.emitting = true
		fuel -= delta * (boost / fuel_usage)
		set_fuel_bar()
	else:
		boost_particle.emitting = false
	
	
	if Input.is_action_just_pressed("anti-gravity"):
		#gravity_scale = -gravity_scale
		gravity_scale = 0
		#anti_gravity_particle.emitting = true
	
	if fuel <= 0:
		crash_smoke_particle.emitting = true
		boost_particle.emitting = false
		thrust_particle.emitting = false
		brake_particle.emitting = false
		right_turn_particle.emitting = false
		left_turn_particle.emitting = false
		engine_audio.stop()
		set_process(false)



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
	crash_smoke_particle.emitting = true
	boost_particle.emitting = false
	thrust_particle.emitting = false
	brake_particle.emitting = false
	right_turn_particle.emitting = false
	left_turn_particle.emitting = false
	engine_audio.stop()
	explosion_audio.play()
	gravity_scale *= 2
	apply_central_force(basis.y * 1000)
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(3.5)
	tween.tween_callback(get_tree().reload_current_scene)
