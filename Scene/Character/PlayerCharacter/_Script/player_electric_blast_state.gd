class_name PlayerElectricBlastState
extends PlayerState

const TIME_BETWEEN_PULSE : float = 1

var _exiting := false
var _time_since_pulse : float = 0
var _direction: Vector2

func enter() -> void:
	super.enter()
	_player.cast_effect(Vector2.ZERO, _player.ELECTRIC_BLAST_SCENE.instantiate())

	var mouse_position := _player.get_local_mouse_position()
	_direction = mouse_position.normalized()
	_player.directional_animator.play_directional("cast", _direction)


func update(delta: float) -> State:
	if Input.is_action_just_released("cast") and not _exiting:
		_exiting = true
		_player.directional_animator.play_directional("cast_exit", _direction)
		
	if _exiting:
		if not _player.directional_animator.is_playing():
			return PlayerCombatState.new(_direction)
	elif _time_since_pulse > TIME_BETWEEN_PULSE and not _exiting:
		_time_since_pulse = 0
		_player.cast_effect(Vector2.ZERO, _player.ELECTRIC_BLAST_SCENE.instantiate())
	
	_time_since_pulse += delta
	return
