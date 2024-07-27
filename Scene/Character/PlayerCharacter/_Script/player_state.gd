class_name PlayerState
extends State

var _player: Player

func enter() -> void:
	_player = state_machine.state_owner as Player
