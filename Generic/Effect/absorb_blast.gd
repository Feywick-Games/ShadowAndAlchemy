class_name AbsorbBlast
extends EffectParticles

@export
var blast_color_ramp: Gradient

var terminating := false

func _process(delta: float) -> void:
	super._process(delta)
	
	if terminating:
		create_surface = false
		if _active_surface:
			_active_surface.queue_free()
			_active_surface = null
		_blast.radial_accel_min = lerp(_blast.radial_accel_min, 0.0, 2 * delta)
		_blast.modulate.a = lerp(_blast.modulate.a, 0.0, 2 * delta)
	if abs(_blast.radial_accel_min) - 5.0 < 0:
		queue_free()

func _on_impact(_body: PhysicsBody2D) -> void:
	terminating = true
