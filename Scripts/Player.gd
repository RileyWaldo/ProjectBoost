extends RigidBody3D

##How much forward force to apply
@export_range(0.0, 3000.0) var thrustForce: float = 1000.0
## How much torque to apply
@export var torqueForce: float = 100.0
## How long in seconds before respawn or next level
@export var delay: float = 2.5

@onready var audioExplosion: AudioStreamPlayer = $Audio/Explosion
@onready var audioSuccess: AudioStreamPlayer = $Audio/Success
@onready var audioRocket: AudioStreamPlayer3D = $Audio/Rocket
@onready var boosterParticles: GPUParticles3D = $Particles/BoosterParticles
@onready var boosteParticlesLeft: GPUParticles3D = $Particles/BoosterParticlesLeft
@onready var boosterParticlesRight: GPUParticles3D = $Particles/BoosterParticlesRight

const goalGroup: String = "Goal"
const deathGroup: String = "Hazard"

var isTransitioning: bool = false

func CrashSequence() -> void:
	if(isTransitioning):
		return
	
	boosterParticles.emitting = false
	audioRocket.stop()
	audioExplosion.play()
	isTransitioning = true
	var tween: Tween = create_tween()
	tween.tween_interval(delay)
	tween.tween_callback(get_tree().reload_current_scene)
	
func CompleteLevel(filePath: String) -> void:
	if(isTransitioning):
		return
	
	audioSuccess.play()
	isTransitioning = true
	var tween: Tween = create_tween()
	tween.tween_interval(delay)
	tween.tween_callback(get_tree().change_scene_to_file.bind(filePath))
	
func MovePlayer(delta: float) -> void:
	boosteParticlesLeft.emitting = false
	boosterParticlesRight.emitting = false
	if(isTransitioning):
		return
	
	if(Input.is_action_pressed("boost")):
		apply_central_force(basis.y * delta * thrustForce)
		
	if(Input.is_action_pressed("rotateLeft")):
		boosteParticlesLeft.emitting = true
		apply_torque(Vector3(0.0, 0.0, torqueForce * delta))
		
	if(Input.is_action_pressed("rotateRight")):
		boosterParticlesRight.emitting = true
		apply_torque(Vector3(0.0, 0.0, -torqueForce * delta))

func _process(delta: float) -> void:
	MovePlayer(delta)
	
	if(!isTransitioning and Input.is_action_just_pressed("boost")):
		audioRocket.play()
		boosterParticles.emitting = true
		
	if(Input.is_action_just_released("boost")):
		audioRocket.stop()
		boosterParticles.emitting = false


func _on_body_entered(body: Node) -> void:
	if(body.is_in_group(goalGroup)):
		CompleteLevel(body.filePath)
	elif(body.is_in_group(deathGroup)):
		CrashSequence()
