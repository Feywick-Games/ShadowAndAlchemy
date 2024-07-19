class_name Character
extends CharacterBody2D

var active_surface: EffectSurface
@export
var cast_width: float = 32
@export
var init_state: GDScript
@export
var speed: float = 50

@onready
var footprint: ColorRect = $Footprint


func _ready() -> void:
	var state_machine := StateMachine.new(self, init_state.new())
	add_child(state_machine)


func _process(delta: float) -> void:
	global_position = global_position.round()


func cast_effect(direction : Vector2, particles: EffectParticles, terminate_signal: Signal = Signal()) -> void:
	particles.position = $ParticlePosition.position.rotated(-direction.angle_to(Vector2.DOWN))
	particles.global_position += global_position
	get_parent().add_child(particles)
	particles.cast(direction)
	
	if terminate_signal != Signal():
		terminate_signal.connect(particles._on_impact.bind(null))


func check_surfaces() -> void:
	for y: int in range(0, footprint.get_rect().size.y):
		for x: int in range(0, footprint.get_rect().size.x):
			var pix := Vector2(x,y) + footprint.global_position
			var pix_color: Color = GameState.effect_image.get_pixelv(pix)
