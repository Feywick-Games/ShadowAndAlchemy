class_name AbsorbBlast
extends EffectParticles

@export
var blast_color_ramp: Gradient
signal termination_scheduled

var terminating := false

func _process(delta: float) -> void:
	super._process(delta)
	
	if terminating:
		create_surface = false
		if _active_surface:
			_active_surface.queue_free()
			_active_surface = null
			termination_scheduled.emit()


func _on_impact(_body: PhysicsBody2D) -> void:
	terminating = true
	_blast.emitting = false
	_blast.lifetime = .5
	_blast.finished.connect(queue_free)



func cast_effect_surface(color: Color) -> void:
	super.cast_effect_surface(color)
	_active_surface.set_visibility_layer_bit(9,true)
