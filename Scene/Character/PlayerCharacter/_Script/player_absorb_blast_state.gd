class_name PlayerAbsorbBlastState
extends PlayerState

signal exiting_state

const EXIT_TIME := .5

var _exiting := false
var _time_exiting: float
var _direction: Vector2

func enter() -> void:
	super.enter()
	var mouse_position := _player.get_local_mouse_position()
	_direction = (mouse_position - _player.position).normalized()
	var mouse_pos: Vector2 = _player.get_global_mouse_position()
	_direction = (mouse_pos - _player.global_position).normalized()
	_player.directional_animator.play_directional("cast", _direction)
	_player.directional_animator.animation_finished.connect(_cast_effect)


func _cast_effect(anim: String) -> void:
	_player.directional_animator.animation_finished.disconnect(_cast_effect)
	_player.cast_effect(_direction, _player.ABSORB_BLAST_SCENE.instantiate(), exiting_state)



func update(delta: float) -> State:
	if Input.is_action_just_released("decompose") and not _exiting:
		exiting_state.emit()
		_player.directional_animator.play_directional("cast_exit", _direction)
		_exiting = true
		
	if _exiting and not   _player.directional_animator.is_playing():
		return PlayerCombatState.new(_direction) 
		
	return
