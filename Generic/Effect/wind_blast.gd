extends EffectParticles

const ALT_MAT: ShaderMaterial = preload("res://Scene/Effect/_Material/effect_smear.material")

func cast_effect_surface(color: Color) -> void:
	if not _active_surface:
		_active_surface = EffectSmear.new(color, global_position, _circle_shape.radius, ALT_MAT)
		get_tree().get_first_node_in_group("effect_group").add_child(_active_surface)
	_active_surface.add_point(global_position, _circle_shape.radius)
	
