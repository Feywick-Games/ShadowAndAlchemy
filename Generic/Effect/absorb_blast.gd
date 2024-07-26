class_name AbsorbBlast
extends EffectParticles

const TIME_PER_REFRESH: float = .5

@export
var blast_color_ramp: Gradient
@export
var player_character: Globals.PlayerCharacter

signal termination_scheduled
signal refresh_absorb

var terminating := false
var time_since_refresh: float = 0

func _process(delta: float) -> void:
	super._process(delta)
	
	if terminating:
		create_surface = false
		if _active_surface:
			_active_surface.queue_free()
			_active_surface = null
			termination_scheduled.emit()

	if time_since_refresh >= TIME_PER_REFRESH:
		refresh_absorb.emit()
		time_since_refresh = 0

	time_since_refresh += delta


func _on_impact(_body: PhysicsBody2D) -> void:
	terminating = true
	_blast.emitting = false
	_blast.lifetime = .5
	_blast.finished.connect(queue_free)



func cast_effect_surface(color: Color) -> void:
	super.cast_effect_surface(color)
	_active_surface.set_visibility_layer_bit(9,true)
