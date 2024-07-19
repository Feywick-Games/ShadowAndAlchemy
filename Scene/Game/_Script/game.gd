class_name Game
extends Node

@onready
var surface_viewport : SubViewport = $SurfaceViewportContainer/SubViewport
@onready
var level_viewport: SubViewport = $LevelViewportContainer/SubViewport
@onready
var effect_map_viewport: SubViewport = %EffectMapViewport

func _ready() -> void:
	effect_map_viewport.world_2d = level_viewport.world_2d


func _process(delta: float) -> void:
	surface_viewport.get_camera_2d().global_position = level_viewport.get_camera_2d().global_position
	RenderingServer.global_shader_parameter_set("effect_map", effect_map_viewport.get_texture())
