class_name ElectricBlast
extends EffectParticles

@export
var _line_widths: int = 8


func _ready() -> void:
	super._ready()
	cast_effect_lines()
	

func cast_effect_lines() -> void:
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
