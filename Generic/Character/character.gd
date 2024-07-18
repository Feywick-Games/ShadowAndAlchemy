class_name Character
extends CharacterBody2D

var active_surface: EffectSurface
@export
var cast_width: float = 32
@export
var init_state: GDScript


func _ready() -> void:
	var state_machine := StateMachine.new(self, init_state.new())
	add_child(state_machine)


func cast_effect(direction : Vector2, particles: EffectParticles) -> void:
	get_parent().add_child(particles)
	particles.cast(direction)
