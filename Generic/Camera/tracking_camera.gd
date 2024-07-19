extends Camera2D

const GAME_SIZE := Vector2i(640,360)

@export
var leader : Node2D
@export_range(0,1)
var lerp_speed: float = 5
@export
var max_speed: float = 1
@onready
var window_scale : Vector2

func _ready() -> void:
	EventBus.cam_follow_requested.connect(_on_cam_follow_requested)
	get_tree().root.get_viewport().size_changed.connect(_set_window_scale)

func _set_window_scale() -> void:
	window_scale = DisplayServer.window_get_size(0) / GAME_SIZE


func _physics_process(delta: float) -> void:
	var distance = global_position.lerp(leader.global_position, lerp_speed * delta).distance_to(global_position)
	var direction: Vector2 = min(max_speed, distance) * (leader.global_position - global_position).normalized()
	global_position += direction * distance
	
	global_position = global_position.round()
	

func _on_cam_follow_requested(node: Node2D) -> void:
	leader = node