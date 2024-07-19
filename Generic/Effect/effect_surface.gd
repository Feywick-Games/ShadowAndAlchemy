class_name EffectSurface
extends Node2D

var type: EffectParticles.SurfaceType
var mesh : Polygon2D = Polygon2D.new()
var image: Image
var radius: int

func _init(color_: Color, point: Vector2, radius_: int) -> void:
	mesh.color = color_
	mesh.set_visibility_layer_bit(0, false)
	mesh.set_visibility_layer_bit(8, true)
	add_child(mesh)
	add_point(point, radius_)
	set_visibility_layer_bit(0, false)
	set_visibility_layer_bit(8, true)
	#set_collision_layer_value(1, false)
	#set_collision_layer_value(9, true)
	#set_collision_mask_value(1, false)
	#set_collision_mask_value(9, true)


func add_point(point: Vector2, radius_: int) -> void:
	global_position = point
	if radius_ != radius:
		radius = radius_
		build_polygon(radius)


func build_polygon(radius: int) -> void:
	assert(radius > 1)
	radius = radius if radius % 2 == 0 else radius - 1
	var resolution: int = max(256, radius * 4)
	var points: PackedVector2Array
	for i: int in range(0, resolution):
		var theta : float = ((TAU / float(resolution)) * i) + (PI / 4.0)
		var x = radius * cos(theta)
		var y = radius * sin(theta)
		#x = floor(x) if x > 0 else ceil(x)
		#y = floor(y) if y > 0 else ceil(y)
		var point = Vector2(x,y).round()
		
		if not point in points:
			points.append(point)
	
	# remove straight lines
	var new_points: PackedVector2Array = [points[0], points[1]]
	for i: int in range(2, len(points)):
		var j = len(new_points) - 2
		if new_points[j].x == points[i].x || new_points[j].y == points[i].y:
			new_points[j + 1] = points[i]
		else:
			new_points.append(points[i])
			
	mesh.polygon = new_points
