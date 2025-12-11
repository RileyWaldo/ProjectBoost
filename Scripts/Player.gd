extends RigidBody3D

##How much forward force to apply
@export_range(0.0, 3000.0) var thrustForce: float = 1000.0
## How much torque to apply
@export var torqueForce: float = 100.0

const goalGroup: String = "Goal"
const deathGroup: String = "Hazard"

func CrashSequence() -> void:
	get_tree().reload_current_scene()
	
func CompleteLevel(filePath: String) -> void:
	get_tree().change_scene_to_file(filePath)

func _process(delta: float) -> void:
	if(Input.is_action_pressed("boost")):
		apply_central_force(basis.y * delta * thrustForce)
		
	if(Input.is_action_pressed("rotateLeft")):
		apply_torque(Vector3(0.0, 0.0, torqueForce * delta))
		
	if(Input.is_action_pressed("rotateRight")):
		apply_torque(Vector3(0.0, 0.0, -torqueForce * delta))


func _on_body_entered(body: Node) -> void:
	if(body.is_in_group(goalGroup)):
		CompleteLevel(body.filePath)
	elif(body.is_in_group(deathGroup)):
		CrashSequence()
