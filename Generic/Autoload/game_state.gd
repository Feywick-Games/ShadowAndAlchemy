extends Node

var effect_image: Image
var _effect_viewport: SubViewport
var effect_map_sprite: Sprite2D
var _reaction_viewport: SubViewport
var reaction_image: Image
var level_size := Vector2(1920,1080)

func _ready() -> void:
	_effect_viewport = get_tree().get_first_node_in_group("effect_viewport")
	if _effect_viewport:
		effect_image = _effect_viewport.get_texture().get_image()
	_reaction_viewport = get_tree().get_first_node_in_group("reaction_viewport")
	if _reaction_viewport:
		reaction_image = _effect_viewport.get_texture().get_image()

func _process(delta: float) -> void:
	if  _effect_viewport:
		effect_image = _effect_viewport.get_texture().get_image()
	if _reaction_viewport:
		reaction_image = _reaction_viewport.get_texture().get_image()
