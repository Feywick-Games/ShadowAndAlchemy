class_name PlayerAbsorbBlastState
extends State

signal exiting_state

const EXIT_TIME := .5

var _player: Player
var _directional_animator: DirectionalAnimator
var _exiting := false
var _time_exiting: float

func enter() -> void:
	_player = state_machine.state_owner as Player
	var mouse_pos: Vector2 = _player.get_global_mouse_position()
	var direction = (mouse_pos - _player.global_position).normalized()
	_player.cast_effect(direction, _player.ABSORB_BLAST_SCENE.instantiate(), exiting_state)
	
	_directional_animator = _player.get_node("DirectionalAnimator")
	_directional_animator.play("idle_down")


func update(delta: float) -> State:
	if Input.is_action_just_released("decompose"):
		exiting_state.emit()
		_exiting = true
		
	if _exiting:
		_time_exiting += delta
		if _time_exiting > .5:
			return PlayerCombatState.new()
		
		
	return
