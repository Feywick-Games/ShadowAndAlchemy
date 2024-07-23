class_name Decomposable
extends RigidBody2D

var collision_polygons: Array[CollisionPolygon2D]
var overlapping_areas: Array[Area2D]
var collision_points: Array[Vector2]
var collision_origins: Array[Vector2]
var raycasts: Array[RayCast2D]

@onready
var absorb_area: Area2D = $Area2D
#@onready
#var absorb_collider: CollisionPolygon2D = $Area2D/CollisionShape2D


func _ready() -> void:
	absorb_area.set_collision_layer_value(10, true)
	absorb_area.set_collision_layer_value(2, true)


func _physics_process(delta: float) -> void:
	collision_points.clear()
	collision_origins.clear()
	
	for i: int in range(len(raycasts)):
		var raycast: RayCast2D = raycasts[i]
		if raycast.is_colliding():
			collision_points.append(raycast.get_collision_point())
			collision_origins.append((raycast.get_collider() as Node2D).global_position)


func _on_area_entered(area: Area2D) -> void:
	var raycast := RayCast2D.new()
	add_child(raycast)
	raycasts.append(raycast)
	overlapping_areas.append(area)


func _on_area_exited(area: Area2D) -> void:
	var idx: int = overlapping_areas.find(area)
	var point := collision_points[idx]
	var origin := collision_origins[idx]
	
	collision_points.remove_at(idx)
	collision_origins.remove_at(idx)
