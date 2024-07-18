class_name Character
extends Node2D

var active_surface: EffectSurface
@export
var cast_width: float = 32

func _process(delta: float) -> void:

	if Input.is_action_just_pressed("cast"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		active_surface = EffectSurface.new(Color.AQUA, mouse_pos, cast_width)
		get_parent().add_child(active_surface)
		active_surface.add_point(mouse_pos, cast_width)
		active_surface.queue_redraw()
	elif Input.is_action_pressed("cast"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		if Time.get_ticks_msec() % 1000 < 500: 
			active_surface.add_point(mouse_pos, cast_width)
		else:
			active_surface.add_point(mouse_pos, 16)
		active_surface.queue_redraw()
	#elif Input.is_action_just_released("cast"):
		#active_surface.queue_free()
		
		
