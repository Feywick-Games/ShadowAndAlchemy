extends Node

var effect_image: Image
var _effect_viewport: SubViewport
var effect_map_sprite: Sprite2D
var _reaction_viewport: SubViewport
var reaction_image: Image
var level_size: Vector2
var set_level_size: Vector2
var current_player: Player
var players : Array[Player]
var _current_player_id: int


func add_player(identifier: String, player: Player) -> void:
	if identifier == "izzy":
		if not players.is_empty():
			players.insert(0, player)
		else:
			players.append(player)
	elif identifier == "chaz":
		if not len(players) < 2:
			players.insert(1, player)
		else:
			player.append(player)
	elif identifier == "mei":
		player.append(player)


func switch_player(right := true) -> void:
	if right:
		if _current_player_id < len(players) - 1:
			_current_player_id += 1
		else:
			_current_player_id = 0
	else:
		if _current_player_id > 0:
			_current_player_id -= 1
		else:
			_current_player_id = len(players) - 1

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
