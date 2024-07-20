class_name EffectLine
extends Node2D

# TODO: rewrite your private variables correctly, you bozo

const NULL_VECTOR := Vector2(2000,2000)

var points: Array[Vector2]
var last_frame_points: Array[Vector2]
var segments: Array[PackedVector2Array]
var radius: float
var last_radius: float
var width: float
var green_id: float
var drawn_init : bool
var switched_material := false
var terminating := false
var width_delta : float = 0

func _init(radius_: int, width_: int) -> void:
	green_id = snapped(randf(), .01)
	radius = radius_
	width = width_
	drawn_init = false
		
	set_visibility_layer_bit(0, false)
	set_visibility_layer_bit(9, true)
	assert(width > 1)
	build_circle(radius)
	queue_redraw()
	add_to_group("lines")
	segments = [points]


func _ready() -> void:
	global_position = global_position.round()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	width_delta = (width * delta * 40)
	radius = radius + width_delta

	print(Time.get_ticks_usec(), " line.gd")
	if terminating:
		queue_free()
	
	if int(floor(last_radius)) < int(floor(radius)) and not terminating:
		last_radius = radius
		build_circle(radius)
		segments.clear()
		segments.append(PackedVector2Array())
		var new_points: Array[Vector2]
		for i: int in range(len(points)):
			var point : Vector2 = points[i]
			if Rect2(0,0, 1920, 1080).has_point(point + global_position):
				var pixel_position := point + global_position
				var pix : Color = GameState.effect_image.get_pixelv(pixel_position)
				
				var o_point: Vector2
				var o_pixel_position
				
				if pix.r > 0 && pix.r < .1:
					o_point = last_frame_points[i]
					o_pixel_position = o_point + global_position
					
					if Rect2(0,0, 1920, 1080).has_point(o_pixel_position):
						var o_pix =  GameState.reaction_image.get_pixelv(o_pixel_position)
						
						if abs(o_pix.g - green_id) < .01 or not drawn_init:
							segments[len(segments) - 1].append(point)
							
					elif i > 0:
						o_point = last_frame_points[i - 1]
						o_pixel_position = o_point + global_position
						
						if Rect2(0,0, 1920, 1080).has_point(o_pixel_position):
							var o_pix =  GameState.reaction_image.get_pixelv(o_pixel_position)
							
							if abs(o_pix.g - green_id) < .01 or not drawn_init:
								segments[len(segments) - 1].append(point)
								
					elif i < len(points) - 1:
						o_point = last_frame_points[i + 1]
						o_pixel_position = o_point + global_position
						
						if Rect2(0,0, 1920, 1080).has_point(o_pixel_position):
							var o_pix =  GameState.reaction_image.get_pixelv(o_pixel_position)
							
							if abs(o_pix.g - green_id) < .01 or not drawn_init:
								segments[len(segments) - 1].append(point)
							
				else:
					segments.append(PackedVector2Array())
				
		if segments.is_empty() or radius > 200:
			terminating = true
		
		queue_redraw()


func build_circle(radius_: int) -> void:
	assert(radius > 1)
	var resolution: int = 512
	last_frame_points = points.duplicate()
	points.clear()
	for i: int in range(0, resolution + 1):
		var theta : float = ((TAU / float(resolution)) * i)
		var x = radius_ * cos(theta)
		var y = radius_ * sin(theta)
		var point = Vector2(x,y).round()
		
		points.append(point)

func _draw() -> void:

	for segment in segments:
		if len(segment) < 2:
			continue
		
		draw_polyline(segment, Color(0, green_id, 0, 1  ), width)
	draw_circle(Vector2.ZERO, radius - width, Color.BLACK)
	
	if terminating:
		draw_circle(Vector2.ZERO, 300, Color.BLACK)
	
	drawn_init = true
		
