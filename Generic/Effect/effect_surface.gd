class_name EffectSurface
extends Node2D

var radius: int
var color: Color

func _init(color_: Color, point: Vector2, radius_: int) -> void:
	color = color_
	radius = radius_
	add_point(point, radius)
	set_visibility_layer_bit(0, false)
	set_visibility_layer_bit(8, true)


func _process(delta: float) -> void:
	queue_redraw()

func add_point(point: Vector2, radius_: int) -> void:
	global_position = point
	if radius_ != radius:
		radius = radius_


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)
