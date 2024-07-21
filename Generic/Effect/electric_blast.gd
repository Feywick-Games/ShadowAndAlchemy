class_name ElectricBlast
extends EffectParticles

@export
var _line_widths: int = 8


func _ready() -> void:
	super._ready()
	cast_effect_lines()
	

func cast_effect_lines() -> void:
	#for i in range(float(_line_widths) / 2.0, _circle_shape.radius, _line_widths):
		var new_line := EffectLine.new(_circle_shape.radius, _line_widths)
		new_line.global_position = global_position
		get_tree().get_first_node_in_group("effect_group").add_child(new_line)



#func flood_fill(start) -> void:
	#var remaining : Array[Vector2] = [start]
#
	#while not remaining.is_empty():
		#var point: Vector2 = remaining[0]
		#remaining.remove_at(0)
		#
		#var pix: Color = GameState.effect_image.get_pixelv(point)
		#
		#if pix.r <= .1 \
		#and pix.r > 0 and pix.g == 0:
		#
			#GameState.effect_image.set_pixelv(point, Color(pix.r, 1, pix.b, pix.a))
#
			#var point_r = point + Vector2.RIGHT
			#var point_l = point + Vector2.LEFT
			#var point_u = point + Vector2.UP
			#var point_d = point + Vector2.DOWN
#
			#if point_r.x > 0 and point_r.x < GameState.effect_image.get_size().x \
			#and point_r.y > 0 and point_r.y < GameState.effect_image.get_size().y:
				#remaining.append(point_r)
#
			#if point_l.x > 0 and point_l.x < GameState.effect_image.get_size().x \
			#and point_l.y > 0 and point_l.y < GameState.effect_image.get_size().y:
				#remaining.append(point_l)
				#
			#if point_u.x > 0 and point_u.x < GameState.effect_image.get_size().x \
			#and point_u.y > 0 and point_u.y < GameState.effect_image.get_size().y:
				#remaining.append(point_u)
#
			#if point_d.x > 0 and point_d.x < GameState.effect_image.get_size().x \
			#and point_d.y > 0 and point_d.y < GameState.effect_image.get_size().y:
				#remaining.append(point_d)
#


#func build_mask(radius: int) -> Array[Vector2]:
	#assert(radius > 1)
	#radius = radius if radius % 2 == 0 else radius - 1
	#var resolution: int = max(256, radius * 4)
	#var points: PackedVector2Array
	#for i: int in range(0, resolution):
		#var theta : float = ((TAU / float(resolution)) * i)
		#var x = radius * cos(theta)
		#var y = radius * sin(theta)
		##x = floor(x) if x > 0 else ceil(x)
		##y = floor(y) if y > 0 else ceil(y)
		#var point = Vector2(x,y).round()
		#
		#if not point in points:
			#points.append(point)
	#
	#var output : Array[Vector2]
	#var matrix: Array[Array]
	#for y: int in range(-radius, radius):
		#var new_line: Array = []
		#var line_min: int
		#var line_max: int
		#for x: int in range(-radius - 1, radius + 1):
			#if Vector2(x,y) in points:
				#line_min = min(line_min, x)
				#line_max = max(line_max, x)
			#
		#for x in range(line_min, line_max + 1):
			#output.append(Vector2(x,y))
	#return output
