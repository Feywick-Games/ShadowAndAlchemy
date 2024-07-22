class_name Geometry
extends Object 

static func generate_arc(radius: int, pixels_per_point: int, start := 0, end := TAU) -> PackedVector2Array:
	assert(radius > 1)
	var resolution: float = radius * (TAU/float(pixels_per_point))
	
	var points: PackedVector2Array
	var theta: float = start
	
	while theta <= end :
		var x = radius * cos(theta)
		var y = radius * sin(theta)
		var point = Vector2(x,y).round()
		points.append(point)
		theta += TAU / resolution
	
	if end == TAU:
		theta = TAU
		var x = radius * cos(theta)
		var y = radius * sin(theta)
		var point = Vector2(x,y).round()
		points.append(point)
		
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
