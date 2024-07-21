class_name EffectSurface
extends Node2D

var radius: int
var color: Color
var last_position: Vector2

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


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius * .95, color)
