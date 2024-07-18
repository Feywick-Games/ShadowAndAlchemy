class_name Game
extends Node

@onready
var surface_viewport : SubViewport = $SurfaceViewportContainer/SubViewport
@onready
var level_viewport: SubViewport = $LevelViewportContainer/SubViewport

func _ready() -> void:
	surface_viewport.world_2d = level_viewport.world_2d


func _process(delta: float) -> void:
	surface_viewport.get_camera_2d().global_position = level_viewport.get_camera_2d().global_position
