class_name Decomposable
extends RigidBody2D

var overlapping_areas: Array[Area2D]

@export
var height_scale_float: float
@export
var max_distance: float = 20

var _init_position: Vector2

@onready
var absorb_area: Area2D = $Area2D
@onready
var _sprite: Sprite2D = $Sprite2D
var _dissolve_time: float = 1.57


#@onready
#var absorb_collider: CollisionPolygon2D = $Area2D/CollisionShape2D


func _ready() -> void:
	absorb_area.set_collision_mask_value(10, true)
	absorb_area.set_collision_mask_value(1,false)
	absorb_area.area_entered.connect(_on_area_entered)
	_init_position = global_position


func _process(delta: float) -> void:
	if _init_position.distance_to(global_position) > max_distance and overlapping_areas.is_empty():
		_dissolve_time -= delta
		
		if not freeze:
			freeze = true
			
		if _dissolve_time > 0:
			_sprite.material.set_shader_parameter("time", _dissolve_time)


	if _dissolve_time <= -0.0001:
		queue_free()
		


func _on_area_entered(area: Area2D) -> void:
	overlapping_areas.append(area)
	area.refresh_absorb.connect(_on_area_exited.bind(area))
	area.termination_scheduled.connect(_absorb_terminated.bind(area))



func _absorb_terminated(absorb: AbsorbBlast) -> void:
	_on_area_exited(absorb)
	var idx := overlapping_areas.find(absorb)
	overlapping_areas.remove_at(idx)


func _on_area_exited(area: AbsorbBlast) -> void:
	
	var collision_polygons: Array[Node] = $StaticBody2D.find_children("*", "CollisionPolygon2D")
	var grav_polygons: Array[Node] = find_children("*", "CollisionPolygon2D", false)
	
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
	var impact: PackedVector2Array = Geometry.generate_arc(radius, 2, 0, TAU, Vector2(1,.75))
	var colors: PackedColorArray
	
	for i in range(len(impact)):
		impact[i] += origin
		colors.append(Color(1 if i%3==0 else 0, 1 if i%3==1 else 0, 1 if i%3==2 else 0))
	
	
	for j: int in range(len(collision_polygons)):
		var poly = collision_polygons[j]
		var polygon: PackedVector2Array = poly.polygon
	
		for i in range(len(polygon)):
			polygon[i] += poly.position
		
		var returned = Geometry.polygon_subtract_b(polygon, impact)
				
		if not returned.is_empty():
			for i: int in range(len(returned)):
				if i == 0:
					poly.set_deferred("polygon", returned[i])
				else:
					var new_poly := CollisionPolygon2D.new()
					new_poly.set_deferred("polygon", returned[i])
					$StaticBody2D.add_child(new_poly)
					new_poly.owner = $StaticBody2D
		else:
			poly.queue_free()

	for j: int in range(len(grav_polygons)):
		var poly = grav_polygons[j]
		var polygon: PackedVector2Array = poly.polygon
	
		for i in range(len(polygon)):
			polygon[i] += poly.position
		
		var returned = Geometry.polygon_subtract_b(polygon, impact)
				
		if not returned.is_empty():
			for i: int in range(len(returned)):
				if i == 0:
					poly.set_deferred("polygon", returned[i])
				else:
					var new_grav := CollisionPolygon2D.new()
					new_grav.set_deferred("polygon", returned[i])
					add_child(new_grav)
					new_grav.owner = self
		else:
			poly.queue_free()


	
	
	var impact_poly := Polygon2D.new()
	add_child(impact_poly)
	impact_poly.set_visibility_layer_bit(0,false)
	impact_poly.set_visibility_layer_bit(9,true)
	impact_poly.polygon = impact
	impact_poly.color = Color.BLUE
	GameState._reaction_viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
