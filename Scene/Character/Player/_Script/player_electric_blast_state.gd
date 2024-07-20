class_name PlayerElectricBlastState
extends State

const TIME_BETWEEN_PULSE : float = .4

var _player: Player
var _directional_animator: DirectionalAnimator
var _exiting := false
var _time_since_exiting : float = 0
var _time_since_pulse : float = 0

func enter() -> void:
	_player = state_machine.state_owner as Player
	_player.cast_effect(Vector2.ZERO, _player.ELECTRIC_BLAST_SCENE.instantiate())
	
	_directional_animator = _player.get_node("DirectionalAnimator")
	_directional_animator.play("idle_down")
	
	
func update(delta: float) -> State:
	if Input.is_action_just_released("cast_b"):
		return PlayerCombatState.new()
		
	if _exiting:
		_time_since_exiting += delta
	
	if _time_since_pulse > TIME_BETWEEN_PULSE and not _exiting:
		_time_since_pulse = 0
		_player.cast_effect(Vector2.ZERO, _player.ELECTRIC_BLAST_SCENE.instantiate())
	
	_time_since_pulse += delta
	return
