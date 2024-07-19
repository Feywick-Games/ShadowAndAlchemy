class_name PlayerElectricBlastState
extends State

var _player: Player
var _directional_animator: DirectionalAnimator

func enter() -> void:
	_player = state_machine.state_owner as Player
	var mouse_pos: Vector2 = _player.get_global_mouse_position()
	var direction = (mouse_pos - _player.global_position).normalized()
	_player.cast_effect(direction, _player.WIND_BLAST_SCENE.instantiate())
	
	_directional_animator = _player.get_node("DirectionalAnimator")
	_directional_animator.play("idle_down")
	await _directional_animator.animation_finished
	state_machine.change_state(PlayerCombatState.new())
