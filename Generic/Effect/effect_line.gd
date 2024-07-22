class_name EffectLine
extends Node2D

# TODO: rewrite your private variables correctly, you bozo



const NULL_VECTOR := Vector2(2000,2000)
const MIN_PUDDLE_DIAMETER : int = 6

var last_frame_segments: Array[PackedVector2Array]
var segments: Array[PackedVector2Array]
var radius: float
var last_radius: float
var width: float
var switched_material := false
var terminating := false

func _init(radius_: int, width_: int) -> void:
	radius = radius_
	width = width_
	set_visibility_layer_bit(0, false)
	set_visibility_layer_bit(9, true)
	assert(width > 1)
	queue_redraw()


func _ready() -> void:
	global_position = global_position.round()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	radius = radius + (width * delta * 15)
		
	if terminating:
		queue_free()
	
	if not terminating and (int(floor(last_radius)) < int(floor(radius)) or last_frame_segments.is_empty()):		
		last_frame_segments = segments.duplicate()
		
		if not last_frame_segments.is_empty():
			segments = find_segments(Geometry.generate_arc(radius, MIN_PUDDLE_DIAMETER), last_frame_segments, radius, radius - last_radius,1)
		else:
			for i: int in range(MIN_PUDDLE_DIAMETER + 1, radius):
				var previous_segments: Array[PackedVector2Array] = [Geometry.generate_arc(i - 1, 1)]
				var circle_points: PackedVector2Array = Geometry.generate_arc(i, 1)
				segments = find_segments(circle_points, previous_segments, i, 1, 1)
				
				radius = i
				
				if segments.is_empty():
					break

		last_radius = radius
		if segments.is_empty() or radius >= 250:
			terminating = true
		queue_redraw()


func find_segments(circle_points: PackedVector2Array, previous_points: Array[PackedVector2Array], current_radius: float, width_delta: float, break_width: int) -> Array[PackedVector2Array]:
	var splits: Array[PackedVector2Array] = split_arc(circle_points, break_width)
	
	if splits.is_empty():
		return []
		
	var valid_segments: Array[PackedVector2Array]
		
	for split in splits:
		if is_valid_segment(split, previous_points, width_delta):
			valid_segments.append(split)
		
	return valid_segments


func split_arc(circle_points: PackedVector2Array, break_width: int, inside:=true, resolution:= 1) -> Array[PackedVector2Array]:
	var splits : Array[PackedVector2Array] = [PackedVector2Array()]
	
	for point in circle_points:
		var pix: Color
		var global_point: Vector2 = point + global_position
		if Rect2(Vector2.ZERO, GameState.level_size).has_point(global_point):
			pix = GameState.effect_image.get_pixelv(point + global_position)
		else:
			pix = Color.BLACK
		
		if pix.r > 0 and pix.r <= Globals.WATER_EFFECT_MASK:
			splits[len(splits) - 1].append(point)
		elif not splits[len(splits) - 1].is_empty():
			splits.append(PackedVector2Array())
	
	return splits


func is_valid_segment(found_segment: PackedVector2Array, previous_points: Array[PackedVector2Array], width_delta: float) -> bool:
	
	for point: Vector2 in found_segment:
		for o_segment: PackedVector2Array in previous_points:
			for o_point: Vector2 in o_segment:
				var dist: float = o_point.distance_to(point)
				if dist <= width_delta + 2:
					return true

	return false

func slice_segment(segment: PackedVector2Array, output: ) -> Array[PackedVector2Array]:
	return PackedVector2Array()


func _draw() -> void:
	for segment in segments:
		if len(segment) > 2:
			draw_polyline(segment, Color(0, 1, 0, 1  ), width)
	
	if not segments.is_empty():
		draw_circle(Vector2.ZERO, radius - width, Color.BLACK)
	
	if terminating:
		draw_circle(Vector2.ZERO, 300, Color.BLACK)
	
		
