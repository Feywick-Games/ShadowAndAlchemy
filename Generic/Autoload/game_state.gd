extends Node

var effect_image: Image

func _ready() -> void:
	effect_image = get_tree().get_first_node_in_group("effect_viewport").get_texture().get_image()



func _process(delta: float) -> void:
	effect_image = get_tree().get_first_node_in_group("effect_viewport").get_texture().get_image()
