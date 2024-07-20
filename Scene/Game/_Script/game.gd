class_name Game
extends Node

@onready
var surface_viewport : SubViewport = $SurfaceViewportContainer/SubViewport
@onready
var level_viewport: SubViewport = $LevelViewportContainer/SubViewport
@onready
var effect_map_viewport: SubViewport = %EffectMapViewport
@onready
var reaction_map_viewport: SubViewport = %ReactionViewport
@onready
var reaction_track_viewport : SubViewport = $ReactionViewportContainer/SubViewport

func _ready() -> void:
	effect_map_viewport.world_2d = level_viewport.world_2d
	reaction_map_viewport.world_2d = level_viewport.world_2d


func _process(delta: float) -> void:
	var line = get_tree().get_first_node_in_group("lines")
	if line:
		print(Time.get_ticks_usec(), " Game.gd")
	surface_viewport.get_camera_2d().global_position  = level_viewport.get_camera_2d().global_position
	reaction_track_viewport.get_camera_2d().global_position = level_viewport.get_camera_2d().global_position
	RenderingServer.global_shader_parameter_set("effect_map", effect_map_viewport.get_texture())
	RenderingServer.global_shader_parameter_set("reaction_map", reaction_map_viewport.get_texture())
