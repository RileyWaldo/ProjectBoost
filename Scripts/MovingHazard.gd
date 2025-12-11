extends AnimatableBody3D

@export var destination: Vector3 = Vector3.ZERO
@export var duration: float = 1.0


func _ready() -> void:
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_property(self, "global_position", global_position, duration)
