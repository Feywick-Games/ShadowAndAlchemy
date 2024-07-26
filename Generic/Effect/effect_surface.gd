class_name EffectSurface
extends Node2D

var radius: int
var color: Color
var last_position: Vector2
var points: PackedVector2Array

func _init(color_: Color, point: Vector2, radius_: int, alt_material = null) -> void:
	color = color_
	radius = radius_
	set_visibility_layer_bit(0, false)
	set_visibility_layer_bit(8, true)
	if alt_material:
		material = alt_material
	add_point(point, radius)


func _process(delta: float) -> void:
	queue_redraw()

func add_point(point: Vector2, radius_: int) -> void:
	last_position = global_position
	global_position = point
	if radius_ != radius:
		radius = radius_
		points = Geometry.generate_arc(radius, 1, 0, TAU, Vector2(1,0.75))


func _draw() -> void:
	if points.size() > 3:
		draw_colored_polygon(points, color)
