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

func _on_impact(_body: PhysicsBody2D) -> void:
	terminating = true
	_blast.emitting = false
	_blast.lifetime = .5
	_blast.finished.connect(queue_free)


func _exit_tree() -> void:
	EventBus.absorb_ended.emit(self)
