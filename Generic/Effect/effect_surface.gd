class_name EffectSurface
extends Area2D

var effect : Effect

var points: PackedVector2Array
var widths: Array[int] = [0]
var line_indices: Array[int] = [0]
var color: Color
var colliders: Array[CollisionShape2D]
var shapes: Array[CollisionShape2D]
var is_absorbed := false

#var colors: PackedColorArray
#var uvs: PackedVector2Array


func _init(color_: Color, point: Vector2, radius: int) -> void:
	self.color = color_
	set_visibility_layer_bit(0, false)
	set_visibility_layer_bit(8, true)
	set_collision_layer_value(1, false)
	set_collision_layer_value(9, true)
	set_collision_mask_value(1, false)
	set_collision_mask_value(9, true)
	
	add_point(point, radius)
	
	area_entered.connect(absorb)


func add_point(point: Vector2, radius: int) -> void:
	var collider := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = radius
	collider.shape = circle
	collider.global_position = point
	add_child(collider)
	colliders.append(collider)


func absorb(o_surface: EffectSurface) -> void:
	
	for collider: CollisionShape2D in o_surface.colliders:
		o_surface.remove_child(collider)
		call_deferred("add_child", collider)
	o_surface.queue_free()


#func absorb(o_surface: EffectSurface) -> void:
	#var lines: Array[Vector2i]
	#
	#for i: int in range(len(o_surface.points)):
		#var index: int = points.find(o_surface.points[i])
		#if index != -1:
			## check if a new line needs to be created
			#if lines.is_empty() || lines[len(lines) - 1].y != -1:
				#var line := Vector2i(index, -1)
				#lines.append(line)
			#else:
				#lines[len(lines) - 1].y = index
	#
	#assert(_check_valid_lines(lines))
	#
	#var new_points: PackedVector2Array = points.slice(0, lines[0].x)
	#for i: int in range(1 , len(lines)):
		#new_points.append_array(points.slice(lines[i - 1].y, lines[i].x))
		#if i + 1 < len(lines):
			#pass
	#
	#new_points.append_array(points.slice(0, lines[len(lines) - 1].y))

#
#func _check_valid_lines(lines: PackedVector2Array) -> bool:
	#for line in lines:
		#if line.y == -1:
			#return true
	#
	#return false


func _draw() -> void:
	for collider: CollisionShape2D in colliders:
		draw_circle(collider.global_position, (collider.shape as CircleShape2D).radius, color)
