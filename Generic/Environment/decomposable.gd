class_name Decomposable
extends RigidBody2D

@onready
var collision_polygon : CollisionPolygon2D = $CollisionPolygon2D

# if polygon point count is 1 queue free
#
#func disintegrate(origin: Vector2, radius: int) -> void:
	#var segments: Array[Array]
	#var o_points := build_circle(radius)
	#build_circle(radius)
	#
	#segments.append(PackedVector2Array())
	#var new_points: Array[Vector2]
	#for i: int in range(len(collision_polygon.polygon)):
		#var point : Vector2 = collision_polygon.polygon[i] + global_position
		#
		#for j: int in range(len(o_points)):
			#
			#var o_point: Vector2 = o_points[j]
			#var ray : Vector2 = (o_psoint - origin)
			#
			#
			#var o_pixel_position
				#
			#if pix.r > 0 && pix.r < .1:
				#o_point = o_points[i]
				#o_pixel_position = o_point + global_position
					#
			#var o_pix =  GameState.reaction_image.get_pixelv(o_pixel_position)
			#
			#if false:
				#segments[len(segments) - 1].append(point)
			#else:
				#segments.append(PackedVector2Array())
	## TODO look for straight lines ?


func build_circle(radius: int) -> PackedVector2Array:
	assert(radius > 1)
	var points: PackedVector2Array
	# WARNING test resolution
	var resolution: int = 128
	points.clear()
	for i: int in range(0, resolution + 1):
		var theta : float = ((TAU / float(resolution)) * i)
		var x = radius * cos(theta)
		var y = radius * sin(theta)
		var point = Vector2(x,y).round()
		
		points.append(point)
	return points
