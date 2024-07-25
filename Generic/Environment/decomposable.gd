class_name Decomposable
extends RigidBody2D

var overlapping_areas: Array[Area2D]

@onready
var absorb_area: Area2D = $Area2D
#@onready
#var absorb_collider: CollisionPolygon2D = $Area2D/CollisionShape2D


func _ready() -> void:
	absorb_area.set_collision_mask_value(10, true)
	absorb_area.area_entered.connect(_on_area_entered)
	EventBus.absorb_ended.connect(_on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	overlapping_areas.append(area)


func _on_area_exited(area: AbsorbBlast) -> void:
	var idx: int = overlapping_areas.find(area)
	
	if idx == -1:
		return
	
	var collision_polygons: Array[Node] = find_children("*", "CollisionPolygon2D")
	
	var i_to_remove: Array[int]
	for i in range(len(collision_polygons)):
		if collision_polygons[i].polygon.size() < 3:
			collision_polygons[i].queue_free()
			i_to_remove.append(i)
	
	var temp: Array[Node]
	for i in range(len(collision_polygons)):
		if not i in i_to_remove:
			temp.append(collision_polygons[i])
	
	collision_polygons = temp
	
	var origin := to_local(area.global_position)
	var radius: int = area.circle_shape.radius
	var impact: PackedVector2Array = Geometry.generate_arc(radius, 64)
	
	var colors: PackedColorArray
	for i in range(len(impact)):
		impact[i] += origin
		colors.append(Color(1 if i%3==0 else 0, 1 if i%3==1 else 0, 1 if i%3==2 else 0))
	
	$Polygon2D.polygon = impact.duplicate()
	$Polygon2D.vertex_colors = colors
	
	for poly in collision_polygons:
		var polygon: PackedVector2Array = poly.polygon
	
		for i in range(len(polygon)):
			polygon[i] += poly.position
		
		var returned = Geometry.polygon_subtract_b(polygon, impact)
		
		if not returned.is_empty():
			for i: int in range(len(returned)):
				if i == 0:
					poly.set_deferred("polygon", returned[i])
					$Polygon2D2.polygons = returned[i]
				else:
					var new_poly := CollisionPolygon2D.new()
					new_poly.set_deferred("polygon", returned[i])
					add_child(new_poly)
					new_poly.owner = self
		else:
			poly.queue_free()
			
	
	overlapping_areas.remove_at(idx)
	
