extends RigidBody3D

# complex stuff I want to do
# missiles
# death counter
# black holes
# biblically accurate angel final boss

#vars
#var player_vector: Vecort3 = Vector3(0, 0, 0)
@export var thrust: int = 2500
@export var brake: int = 2500
@export var boost: int = 4000
@export var turnForce: int = 1000

@export var fuel: float = 100
@export var fuel_efficiency: float = 1000
var max_fuel: float = fuel

# stops the win and crash commands from executing multiple times
var is_transitioning: bool = false

# audio
@onready var explosion_audio: AudioStreamPlayer = $Audio/Explosion_Audio
@onready var win_audio: AudioStreamPlayer = $Audio/Win_Audio
@onready var engine_audio: AudioStreamPlayer = $Audio/Engine_Audio
@onready var brake_audio: AudioStreamPlayer = $Audio/Brake_Audio
@onready var turn_L_audio: AudioStreamPlayer = $Audio/Hiss_L_Audio
@onready var turn_R_audio: AudioStreamPlayer = $Audio/Hiss_R_Audio
@onready var boost_audio: AudioStreamPlayer = $Audio/Boost_Audio

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
#	$Fuel_Level.get_surface_override_material(0).albedo_color += Vector3(1, 0, 0) / fuel_bar_decrease
	$Fuel_Level.position -= Vector3(0, 1, 0) / (fuel_efficiency * 10)
	$Fuel_Level.scale -= Vector3(0, 1, 0) / (fuel_efficiency * 10)
	

func turn_off_effects() -> void:
		boost_particle.emitting = false
		thrust_particle.emitting = false
		brake_particle.emitting = false
		right_turn_particle.emitting = false
		left_turn_particle.emitting = false
		engine_audio.stop()
		brake_audio.stop()
		turn_L_audio.stop()
		turn_R_audio.stop()
		boost_audio.stop()

# movement code
func _process(delta: float) -> void:
	# accelerate
	if Input.is_action_pressed("thrust"):
		apply_central_force(basis.y * delta * thrust)
		thrust_particle.emitting = true
		fuel -= delta * (thrust / fuel_efficiency)
		set_fuel_bar()
		if engine_audio.playing == false:
			engine_audio.play()
	else:
		engine_audio.stop()
		thrust_particle.emitting = false
	
	if Input.is_action_pressed("brake"):
		apply_central_force(-basis.y * delta * brake)
		brake_particle.emitting = true
		fuel -= delta * (brake / fuel_efficiency)
		set_fuel_bar()
		if brake_audio.playing == false:
			brake_audio.play()
	else:
		brake_particle.emitting = false
		brake_audio.stop()
	
	# turn left
	if Input.is_action_pressed("turn_left"):
		apply_torque(Vector3(0, 0, delta * -turnForce))
		apply_central_force(basis.y * delta * turnForce)
		right_turn_particle.emitting = true
		fuel -= delta * (turnForce / fuel_efficiency)
		set_fuel_bar()
		if turn_L_audio.playing == false:
			turn_L_audio.play()
	else:
		right_turn_particle.emitting = false
		turn_L_audio.stop()
	
	# turn right
	if Input.is_action_pressed("turn_right"):
		apply_torque(Vector3(0, 0, delta * turnForce))
		apply_central_force(basis.y * delta * turnForce)
		left_turn_particle.emitting = true
		fuel -= delta * (turnForce / fuel_efficiency)
		set_fuel_bar()
		if turn_R_audio.playing == false:
			turn_R_audio.play()
	else:
		left_turn_particle.emitting = false
		turn_R_audio.stop()

	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * boost)
		boost_particle.emitting = true
		fuel -= delta * (boost / fuel_efficiency)
		set_fuel_bar()
		if boost_audio.playing == false:
			boost_audio.play()
	else:
		boost_particle.emitting = false
		boost_audio.stop()
	
	
	if Input.is_action_just_pressed("anti-gravity"):
		#gravity_scale = -gravity_scale
		gravity_scale = 0
		#anti_gravity_particle.emitting = true
	
	if Input.is_action_just_pressed("decrease_fuel"):
		fuel = 0
		set_fuel_bar()
	
	if fuel <= 0:
		gravity_scale = 2
		fuel = 0
		crash_smoke_particle.emitting = true
		turn_off_effects()
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
	turn_off_effects()
	set_fuel_bar()
	explode_particle.emitting = true
	crash_smoke_particle.emitting = true
	explosion_audio.play()
	gravity_scale *= 2
	apply_central_force(basis.y * 1000)
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2)
	tween.tween_callback(get_tree().reload_current_scene)
