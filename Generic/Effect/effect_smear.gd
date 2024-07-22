class_name EffectSmear
extends EffectSurface

var points: PackedVector2Array
var uvs: PackedVector2Array
var last_frame_points: PackedVector2Array
var last_radius: int
var colors: Array[Color]


func add_point(point: Vector2, radius_: int) -> void:
	if radius_ != radius:
		last_radius = radius
	build_circle(radius_)
	super.add_point(point, radius)


func build_circle(radius_: int) -> void:
	assert(radius_ > 1)
	
	var resolution: int = 512
	last_frame_points = points.duplicate()
	colors.clear()
	points.clear()
	for i: int in range(0, resolution + 1):
		var theta : float = ((TAU / float(resolution)) * i)
		var x = radius_ * cos(theta)
		var y = radius_ * sin(theta)
		
		var point = Vector2(x,y).round()
		
		points.append(point)
		colors.append(Color(1,1,1))
	
	uvs.clear()
	for point: Vector2 in last_frame_points:
		var point_world: Vector2 = point + global_position
		var uv := ((point_world) / (GameState.level_size))
		# WARNING this might be odd or add an impact
		uv = uv.clamp(-Vector2.ONE, Vector2.ONE)
	
		if (global_position - last_position).dot(point) > 0:
			uv -= (global_position - last_position) / GameState.level_size * radius
		uvs.append(uv)



func _draw() -> void:
	var tex := GameState._effect_viewport.get_texture()
	draw_polygon(points, [], uvs, tex)

	#draw_colored_polygon(last_frame_points, Color.BLACK, uvs)
