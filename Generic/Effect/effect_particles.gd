class_name EffectParticles
extends Area2D

enum SurfaceType {
	FIRE,
	WATER
}

@export_range(0, 255)
var force_scale: float
@export
var _terminate_blast_on_impact := true
@export
var _hit_box_scale_curve: Curve2D
@export_range(0,3.0)
var lifetime: float = -1
@export
var has_impact := true
@export
var create_surface := false
@export
var surface_type : SurfaceType


var _initial_lifetime: float
var _max_distance: float


var _force: Vector2
var _blast_time: float
var _offset: Vector2
var _active_surface: EffectSurface
var _hitbox_scale_index: float

@onready
var _blast: CPUParticles2D = $Blast
@onready
var _impact: CPUParticles2D = get_node_or_null("Impact")
@onready
var _circle_shape: CircleShape2D = ($CollisionShape2D as CollisionShape2D).shape


func _ready() -> void:
	_blast.emitting = true
	set_collision_layer_value(1, true)
	set_collision_mask_value(3, true)
	if has_impact:
		body_entered.connect(_on_impact)
	_blast.lifetime = lifetime
	_offset = position
	_blast.show()
	_impact.show()
	_impact.emitting = false
	_impact.one_shot = true


func _process(delta: float) -> void:
	if lifetime > 0:
		_blast_time += delta
	
	if _blast_time >= lifetime:
		_on_impact(null)
	
	if create_surface:
		cast_effect_surface()


func _physics_process(delta: float) -> void:
	if _blast.visible and _terminate_blast_on_impact:
		if _hit_box_scale_curve:
			_circle_shape.radius += _hit_box_scale_curve.sample(int(floor(_hitbox_scale_index)), 0).y
		
		position += _force * force_scale
		cast_effect_surface()
		
	_hitbox_scale_index += delta


func cast(cast_direction: Vector2) -> void:
	_force = cast_direction
	_blast.direction = cast_direction


func cast_effect_surface() -> void:
	if not _active_surface:
		_active_surface = EffectSurface.new(Color.AQUA, global_position, _circle_shape.radius)
		get_tree().get_first_node_in_group("effect_group").add_child(_active_surface)
	_active_surface.add_point(global_position, _circle_shape.radius)


func _on_impact(body: PhysicsBody2D) -> void:
	if _terminate_blast_on_impact:
		_blast.hide()
	if _impact:
		_impact.emitting = true
		await _impact.finished
		_active_surface.queue_free()
		queue_free()