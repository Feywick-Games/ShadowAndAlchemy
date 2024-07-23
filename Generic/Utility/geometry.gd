class_name Geometry
extends Object 

static func generate_arc(radius: int, pixels_per_point: int, start := 0, end := TAU) -> PackedVector2Array:
	assert(radius > 1)
	var resolution: float = radius * (TAU/float(pixels_per_point))
	
	var points: PackedVector2Array
	var theta: float = end
	
	while theta >= start :
		var x = radius * cos(theta)
		var y = radius * sin(theta)
		var point = Vector2(x,y).round()
		points.append(point)
		theta -= TAU / resolution
		
	return points



static func generate_polygon(radius: int, sides: int) -> PackedVector2Array:
	var resolution: float = TAU/float(sides)
	
	var points: PackedVector2Array
	var theta: float
	var start: float
	var end: float
	
	if sides % 2 != 0:
		start = - (PI/sides / 2.0)
	else:
		start = - (PI/sides)
	
	end = start + TAU
	
	theta = start
	
	while theta <= end:
		var x = radius * cos(theta)
		var y = radius * -sin(theta)
		var point = Vector2(x,y).round()
		points.append(point)
		theta += resolution
		
	return points


static func generate_filled_circle(radius: int) -> Array[Vector2]:
	assert(radius > 1)
	radius = radius if radius % 2 == 0 else radius - 1
	var resolution: int = max(256, radius * TAU)
	var points: PackedVector2Array
	
	var theta: float = 0
	
	while theta <= TAU:
		var x = radius * cos(theta)
		var y = radius * sin(theta)
		var point = Vector2(x,y).round()
		points.append(point)
		theta += (TAU / float(resolution))
	
	
	var output : Array[Vector2]
	var matrix: Array[Array]
	for y: int in range(-radius, radius):
		var new_line: Array = []
		var line_min: int
		var line_max: int
		for x: int in range(-radius - 1, radius + 1):
			if Vector2(x,y) in points:
				line_min = min(line_min, x)
				line_max = max(line_max, x)
			
		for x in range(line_min, line_max + 1):
			output.append(Vector2(x,y))
	return output


static func ccw(A: Vector2,B: Vector2,C: Vector2):
	return (C.y-A.y)*(B.x-A.x) > (B.y-A.y)*(C.x-A.x)


static func intersect(A: Vector2,B: Vector2,C: Vector2,D: Vector2):
	return ccw(A,C,D) != ccw(B,C,D) and ccw(A,B,C) != ccw(A,B,D)


static func polygon_subtract_b(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array) -> Array[PackedVector2Array]:
	
	var new_polygons: Array[PackedVector2Array]
	var edges: Dictionary
	var is_inside := polygon_has_point(polygon_a, polygon_b[0])
	var discard_indices: Array[Vector2i] 
	var inside_count: int = 0
	
	for i in range(len(polygon_a)):
		if i != len(polygon_a) - 1:
			if polygon_a[i] != polygon_a[i + 1]:
				edges[polygon_a[i]] = polygon_a[i + 1]
		else:
			if polygon_a[i] != polygon_a[0]:
				edges[polygon_a[i]] = polygon_a[0]
	
	var i: int = 0
	while i < len(polygon_b):
		
		var b0: int = i
		var b1: int
		
		var point123 = polygon_b[b0]
		
		if i == len(polygon_b) - 1:
			b1 = 0
		else:
			b1 = i + 1
		
		if is_inside:
			if polygon_b[b0] != polygon_b[b1]:
				edges[polygon_b[b1]] = polygon_b[b0]
		
		for j: int in range(len(polygon_a)):
			
			var a0: int = j
			var a1: int 
			
			if j == len(polygon_a) -1:
				a1 = 0
			else:
				a1 = j + 1
			
			if intersect(polygon_a[a0], polygon_a[a1], polygon_b[b0], polygon_b[b1]):
				var normal_a = (polygon_a[a0] - polygon_a[a1]).rotated(PI/2).normalized()
				var normal_b = (polygon_b[b0] - polygon_b[b1]).normalized()
				var intersection_point := line_intersection(polygon_a[a0], polygon_a[a1], polygon_b[b0], polygon_b[b1])
				if normal_a.dot(normal_b) <= 0:
					is_inside = true

					if not polygon_has_point(polygon_a, polygon_b[b1]):
						var interp_point := intersection_point + (polygon_b[b1] - polygon_b[b0]).normalized()
						if b1 != 0:
							polygon_b.insert(b1, interp_point)
						else:
							polygon_b.append(interp_point)
						edges[interp_point] = intersection_point
						
					if polygon_b[b1] != intersection_point:
						edges[polygon_b[b1]] = intersection_point
					if intersection_point != polygon_a[a1]:
						edges[intersection_point] = polygon_a[a1]
				else:
					is_inside = false

					if polygon_has_point(polygon_a, polygon_b[b0]):
						if edges.has(polygon_b[b1]):
							edges.erase(polygon_b[b1])

							if intersection_point != polygon_b[b0]:
								edges[intersection_point] = polygon_b[b0]
								
						if polygon_a[a0] != intersection_point:
							edges[polygon_a[a0]] = intersection_point

		i+=1
	
	# isolate and return generated polygons
	var visited: Array[Vector2]
	var vert: Vector2 = edges.keys()[0]
	new_polygons.append(PackedVector2Array([vert]))
	while not has_same_elements(edges.keys(), visited):

		if edges.has(vert):
			if not vert in visited:
				var idx: int = new_polygons[-1].find(vert)
				if idx != -1:
					
					if idx < len(new_polygons[-1]) - 1:
						new_polygons[-1].insert(idx + 1, edges[vert])
					else:
						new_polygons[-1].insert(0, edges[vert])
					visited.append(vert)
			else:
				if not left_outer_join(edges.keys(), visited).is_empty():
					vert = left_outer_join(edges.keys(), visited)[0]
					new_polygons.append(PackedVector2Array([vert]))
					visited.append(vert)
			vert = edges[vert]
		else:
			if not left_outer_join(edges.keys(), visited).is_empty():
				vert = left_outer_join(edges.keys(), visited)[0]
				new_polygons.append(PackedVector2Array([vert]))
				visited.append(vert)
	return new_polygons


static func polygon_has_point(polygon : PackedVector2Array, point: Vector2) -> bool:
	var max_y: float = -INF
	var min_y: float = INF
	
	for vertex in polygon:
		if vertex.y < min_y:
			min_y = vertex.y
		if vertex.y > max_y:
			max_y = vertex.y 
	
	if point.y > max_y or point.y < min_y:
		return false
	
	var intersect_count := 0
	for i in range(len(polygon)):
		if i != len(polygon) - 1:
			if intersect(point,Vector2(point.x, max_y),polygon[i], polygon[i+1]):
				intersect_count += 1
		else:
			if intersect(point,Vector2(point.x, max_y),polygon[i], polygon[0]):
				intersect_count += 1
	
	return intersect_count% 2 != 0


static func has_same_elements(a: Array, b: Array) -> bool:
	for e0 in a:
		if not e0 in b:
			return false
	return true

static func left_outer_join(a: Array, b:Array):
	return a.filter(func(x): return not x in b)


static func line_intersection(a_0: Vector2, a_1: Vector2, b_0: Vector2, b_1: Vector2) -> Vector2:
	var xdiff = [a_0.x - a_1.x, b_0.x - b_1.x]
	var ydiff = [a_0.y - a_1.y, b_0.y - b_1.y]
	
	var div = det(xdiff, ydiff)
	if div == 0:
		return Vector2.INF
	var d = [det([a_0.x, a_0.y], [a_1.x, a_1.y]), det([b_0.x, b_0.y], [b_1.x, b_1.y])]
	var x = det(d, xdiff) / div
	var y = det(d, ydiff) / div
	
	return Vector2(x, y)
	

# calculates determinant between two vectors
static func det(a: Array, b: Array) -> float:
	return a[0] * b[1] - a[1] * b[0]
