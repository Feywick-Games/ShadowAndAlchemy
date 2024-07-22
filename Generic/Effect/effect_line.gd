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
	radius = radius + (width * delta * 5)

	if terminating:
		queue_free()
	
	if not terminating and (int(floor(last_radius)) < int(floor(radius)) or last_frame_segments.is_empty()):		
		last_frame_segments = segments.duplicate()
		
		if not last_frame_segments.is_empty():
			segments = find_segments(Geometry.generate_arc(radius, MIN_PUDDLE_DIAMETER), last_frame_segments, radius, radius - last_radius, MIN_PUDDLE_DIAMETER + 1)
		else:
			for i: int in range(MIN_PUDDLE_DIAMETER + 1, radius):
				var previous_segments: Array[PackedVector2Array] = [Geometry.generate_arc(i - 1, 1)]
				var circle_points: PackedVector2Array = Geometry.generate_arc(i, 1)
				segments = find_segments(circle_points, previous_segments, i, 1, 4)
				
				radius = i
				
				if segments != null:
					break

		last_radius = radius
		if segments.is_empty() or radius >= 250:
			terminating = true
		queue_redraw()


func find_segments(circle_points: PackedVector2Array, previous_points: Array[PackedVector2Array], current_radius: float, width_delta: float, break_width: int) -> Array[PackedVector2Array]:
	
	var start_ends : Array[Vector2i] = [-Vector2i.ONE]
		
	var found_points: int = 0
	var started_in_water := false
	var last_point_water := false
	var first_exit: int
	
	for i: int in range(0, len(circle_points), 1):
		var pixel_position := circle_points[i] + global_position
		var pix: Color
		
		if Rect2(Vector2.ZERO, GameState.level_size).has_point(pixel_position):
			pix = GameState.effect_image.get_pixelv(pixel_position)
		else:
			pix = Color.BLACK
		# grab the last empty position or the current if index is 0
		if pix.r > 0 && pix.r <= Globals.WATER_EFFECT_MASK:
			found_points += 1
			last_point_water = true
			
			if i == 0:
				started_in_water = true

			if i == len(circle_points) - 1 and started_in_water:
				if not start_ends.is_empty():
					start_ends[len(start_ends) - 1].x = first_exit
		else:
			# is non first start point
			if start_ends[len(start_ends) - 1].x == -1:
				if start_ends.size() == 1 and started_in_water:
					first_exit = i
				start_ends[len(start_ends) - 1].x = i
			# replace start if consecutive open spaces
			elif not last_point_water and i < len(circle_points) - 1:
				start_ends[len(start_ends) - 1].x =  i
			# is an end point
			else:
				start_ends[len(start_ends) - 1].y = i
				start_ends.append(Vector2i(-1,-1))
			
			last_point_water = false
	
	
	if found_points == len(circle_points):
		start_ends = [Vector2i(0, circle_points.size() - 1)]
	
	if start_ends[len(start_ends) - 1].x == -1 or start_ends[len(start_ends) - 1].y == -1:
		start_ends.pop_back()
	
	# begin exit state if no segements found
	if (start_ends.is_empty()):
		return []
	
	else:
		var new_segments: Array[PackedVector2Array]
		
		for start_end in start_ends:
			
			var new_segment: PackedVector2Array 
			
			if abs(len(circle_points) - 1 - start_end.y) <= MIN_PUDDLE_DIAMETER:
				new_segment = circle_points.slice(start_end.x)
				new_segment.append(circle_points[0])
			elif start_end[0] < start_end[1]:
				new_segment = circle_points.slice(start_end.x, start_end.y)
			else:
				new_segment = circle_points.slice(start_end.x)
				new_segment.append_array(circle_points.slice(0, start_end.y))
			
			if new_segment.size() == 1:
				continue
			
			var missed_points: int = 0
			# TODO change to Array[Vector2i]
			var segment_indices: Array[PackedInt32Array] = [PackedInt32Array([-1,-1])]
			
			for i: int in range(0,len(new_segment)):
				var point := new_segment[i]
			
				var pixel_position := point + global_position
				var pix : Color
				if Rect2(Vector2.ZERO, GameState.level_size).has_point(point + global_position):
					pix = GameState.effect_image.get_pixelv(pixel_position)
				else:
					pix = Color.BLACK
				
				if pix.r > 0 && pix.r <= .1:
					# if not existing start
					if segment_indices[len(segment_indices) - 1][0] == -1:
						segment_indices[len(segment_indices) - 1][0] = i
					# if no existing end
					if segment_indices[len(segment_indices) - 1][1] == -1:
						segment_indices[len(segment_indices) - 1][1] = i
					# update end
					else:
						segment_indices[len(segment_indices) - 1][1] = i
				else:
					# increment invalid count
					missed_points += 1
					# if too many invalid the segment count is incremented
					if missed_points == break_width:
						if not segment_indices[len(segment_indices) - 1][0] == -1:
							# reset invalid count
							missed_points = 0
							segment_indices.append(PackedInt32Array([-1,-1]))
		
			if segment_indices[len(segment_indices) - 1].is_empty():
				segment_indices.pop_back()
			
			# exclude single point segments
			if segment_indices.is_empty():
				continue
			
			var found_segments: Array[PackedVector2Array] 
			for indices in segment_indices:
				found_segments.append(new_segment.slice(indices[0], indices[1]))
						
			# if a single pixel connects then the whole segment is validated
			for found_segment in found_segments:
				var is_validated := false
				for point: Vector2 in found_segment:
					
					for o_segment in previous_points:
						for o_point in o_segment:
							var dist: float = o_point.distance_to(point)
						

							if dist <= width_delta + 1:
								is_validated = true
								break
						if is_validated:
							break
					if is_validated:
						break
				
				if is_validated:
					new_segments.append(found_segment)
				else:
					print("test")
			
		return new_segments


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
	
		
