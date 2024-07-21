class_name EffectSubtract
extends Node2D


var radius: int
var color: Color
var terminate := false
var has_cleaned_up := false

func _ready() -> void:
	set_visibility_layer_bit(0, false)
	set_visibility_layer_bit(8, true)


func _physics_process(delta: float) -> void:
	if has_cleaned_up:
		queue_free()
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)
	
	if terminate:
		draw_rect(Rect2(-1000, -1000, 2000, 2000), color, true)
		has_cleaned_up = true
