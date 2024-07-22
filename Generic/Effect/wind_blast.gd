class_name WindBlast
extends EffectParticles

const ALT_MAT: ShaderMaterial = preload("res://Scene/Effect/_Material/effect_smear.material")

var _target_angle: float

func cast_effect_surface(color: Color) -> void:
	if not _active_surface:
		_active_surface = EffectSmear.new(color, global_position, _circle_shape.radius, ALT_MAT)
		get_tree().get_first_node_in_group("effect_group").add_child(_active_surface)
	_active_surface.add_point(global_position, _circle_shape.radius)
	
func steer(direction: Vector2) -> void:
	_target_angle = direction.angle()


func _physics_process(delta: float) -> void:
	if _target_angle > 1:
		cast(_force.rotated(-PI * delta))
	elif _target_angle < 1:
		cast(_force.rotated(PI * delta))
	
	_target_angle = 1
	super._physics_process(delta)
