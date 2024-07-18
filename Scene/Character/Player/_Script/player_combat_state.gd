class_name PlayerCombatState
extends State

var _player: Player

func enter() -> void:
	_player = state_machine.state_owner as Player

func update(_delta: float) -> State:
	if Input.is_action_just_pressed("cast"):
		var mouse_pos: Vector2 = _player.get_global_mouse_position()
		var direction = (mouse_pos - _player.global_position).normalized()
		_player.cast_effect(direction, _player.WIND_BLAST_SCENE.instantiate())
	if Input.is_action_just_released("cast"):
		_player.active_surface = null
	
	
	
	return
