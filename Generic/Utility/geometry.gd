class_name Geometry
extends Object 

static func generate_arc(radius: int, pixels_per_point: int, start := 0, end := TAU, scale := Vector2.ONE, repeat_end := false) -> PackedVector2Array:
	assert(radius > 1)
	var resolution: float = radius * (TAU/float(pixels_per_point))
	
	var points: PackedVector2Array
	var theta: float = 0
	
	while theta <= end :
		var x = radius * cos(theta)
		var y = radius * sin(theta)
		var point = (Vector2(x,y) * scale).round()
		points.append(point)
		theta += TAU / resolution
	
	
	if repeat_end:
		points.append(points[0])
	
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
		var y = radius * -sin(theta)
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


static func is_clockwise(A: Vector2,B: Vector2,C: Vector2):
	return (C.y-A.y)*(B.x-A.x) > (B.y-A.y)*(C.x-A.x)


static func intersect(A: Vector2,B: Vector2,C: Vector2,D: Vector2):
	return is_clockwise(A,C,D) != is_clockwise(B,C,D) and is_clockwise(A,B,C) != is_clockwise(A,B,D)


static func polygon_subtract_b(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array) -> Array[PackedVector2Array]:
	
	var new_polygons: Array[PackedVector2Array]
	var edges: Dictionary
	var is_inside: bool
	var discard_indices: Array[Vector2i] 
	var inside_count: int = 0
	
	for i in range(len(polygon_b)):
		if not polygon_has_point(polygon_a, polygon_b[i]):
			var temp := polygon_b.slice(i)
			temp.append_array(polygon_b.slice(0, i))
			polygon_b = temp
			break
	
	
	if not polygon_is_clockwise(polygon_a):
		polygon_a.reverse()
		
	if not polygon_is_clockwise(polygon_b):
		polygon_a.reverse()
	
	if polygon_a.size() < 3:
		return []
	if polygon_b.size() < 3:
		return [polygon_a]
	
	var temp: PackedVector2Array
	
	for point in polygon_a:
		if not point in temp:
			temp.append(point)
	polygon_a = temp.duplicate()
	temp.clear()
	for point in polygon_b:
		if not point in temp:
			temp.append(point)
	polygon_b = temp.duplicate()
	
	for i in range(len(polygon_a)):
		if i != len(polygon_a) - 1:
			if polygon_a[i] != polygon_a[i + 1]:
				edges[polygon_a[i]] = polygon_a[i + 1]
		else:
			if polygon_a[i] != polygon_a[0]:
				edges[polygon_a[i]] = polygon_a[0]
	
	for key in edges:
		if polygon_has_point(polygon_b, key):
			edges.erase(key)
	
	
	var i: int = 0
	while i < len(polygon_b):
		
		var b0: int = i
		var b1: int
		
		var point123 = polygon_b[b0]
		
		if i == len(polygon_b) - 1:
			b1 = 0
		else:
			b1 = i + 1
		

		
		for j: int in range(len(polygon_a)):
			
			var a0: int = j
			var a1: int 
			
			if j == len(polygon_a) -1:
				a1 = 0
			else:
				a1 = j + 1
			
			if intersect(polygon_a[a0], polygon_a[a1], polygon_b[b0], polygon_b[b1]):
				var normal_a = (polygon_a[a1] - polygon_a[a0]).rotated(-PI/2).normalized()
				var normal_b = (polygon_b[b1] - polygon_b[b0]).normalized()
				print(normal_a)
				print(normal_b)
				print(normal_a.dot(normal_b))
				var intersection_point := line_intersection(polygon_a[a0], polygon_a[a1], polygon_b[b0], polygon_b[b1]).round()
				if normal_a.dot(normal_b) < 0:
					is_inside = true

					if not polygon_has_point(polygon_a, polygon_b[b1]):
						var interp_point := intersection_point + (polygon_b[b1] - intersection_point).normalized()
						if b1 != 0:
							polygon_b.insert(b1, interp_point)
						else:
							polygon_b.append(interp_point)
						print("interp")
						edges[interp_point] = intersection_point
					#else:
						#edges.erase(polygon_a[a0])
					if polygon_b[b1] != intersection_point:
						edges[polygon_b[b1]] = intersection_point
					if intersection_point != polygon_a[a1]:
						edges[intersection_point] = polygon_a[a1]
					#if polygon_has_point(polygon_b, polygon_a[a0]):
						#edges.erase(a0)
					break
				elif normal_a.dot(normal_b) > 0:
					is_inside = false

					if polygon_has_point(polygon_a, polygon_b[b0]):
						if intersection_point != polygon_b[b0]:
							edges[intersection_point] = polygon_b[b0]
								
						if polygon_a[a0] != intersection_point:
							edges[polygon_a[a0]] = intersection_point
						break
					
			if is_inside and j == len(polygon_a) - 1:
				if polygon_b[b0] != polygon_b[b1]:
					edges[polygon_b[b1]] = polygon_b[b0]
		i+=1
	
	if edges.keys().size() == polygon_a.size():
		for point in polygon_a:
			if polygon_has_point(polygon_b, point):
				return []
		return [polygon_a]
	# isolate and return generated polygons
	var visited: Array[Vector2]
	var vert: Vector2 = edges.keys()[0]
	var links: PackedVector2Array
	var discard: Array[PackedVector2Array]
	links.append(vert)
	while not has_same_elements(edges.keys(), visited):
		if edges.has(vert) and not vert in visited:
			var idx: int = links.find(vert)
			var loops: bool = links.has(edges[vert])
			if idx != -1 and not loops:
				
				if idx < len(links) - 1:
					links.insert(idx + 1, edges[vert])
				else:
					links.insert(0, edges[vert])
				visited.append(vert)
				vert = edges[vert]
			else:
				if loops:
					var output: PackedVector2Array
					# WARNING: this is a manual clean up that may produce inconsistent results
					# Used for hanging vertices
					for point in links:
						if not polygon_has_point(polygon_b, point):
							output.append(point)
					
					new_polygons.append(output)
					#else:
						#links.reverse()
						#new_polygons.append(links.duplicate())
				else:
					discard.append(links.duplicate())
				vert = left_outer_join(edges.keys(), visited)[0]
				links.clear()
				links.append(vert)
		else:
			if not left_outer_join(edges.keys(), visited).is_empty():
				vert = left_outer_join(edges.keys(), visited)[0]
				links.clear()
				links.append(vert)

	return new_polygons


static func polygon_is_clockwise(polygon: PackedVector2Array) -> bool:
	var diff: float
	
	for i in range(len(polygon)):
		var j:int = i+1
		if i == len(polygon) - 1:
			j= 0
		diff += (polygon[j].x - polygon[i].x) * (polygon[j].y + polygon[i].y)
		
	return diff < 0


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
	
	max_y += 1
	min_y -= 1
	
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
