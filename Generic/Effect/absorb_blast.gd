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
var _border_surface: EffectSurface

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
	_border_surface.queue_free()


func cast_effect_surface(color: Color) -> void:
	super.cast_effect_surface(color)
	if not _active_surface.get_visibility_layer_bit(9):
		_active_surface.set_visibility_layer_bit(9,true)
	if not _border_surface:
		_border_surface = EffectSurface.new(Color(0,0,1,1), global_position, max(circle_shape.radius - 6,2))
		get_tree().get_first_node_in_group("effect_group").add_child(_border_surface)
		_border_surface.set_visibility_layer_bit(8,false)
		_border_surface.set_visibility_layer_bit(9,true)
		var new_mat := CanvasItemMaterial.new()
		new_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		_active_surface.material = new_mat       
	_border_surface.add_point(global_position, max(circle_shape.radius - 6,2))
