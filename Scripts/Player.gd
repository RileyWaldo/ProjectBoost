extends RigidBody3D

@export var thrustForce: float = 1000.0
@export var torqueForce: float = 100.0

func _process(delta: float) -> void:
	if(Input.is_action_pressed("ui_accept")):
		apply_central_force(basis.y * delta * thrustForce)
		
	if(Input.is_action_pressed("ui_left")):
		apply_torque(Vector3(0.0, 0.0, torqueForce * delta))
		
	if(Input.is_action_pressed("ui_right")):
		apply_torque(Vector3(0.0, 0.0, -torqueForce * delta))
