class_name PlayerPunchState
extends PlayerState

const TIME_TILL_BUFFER: float = 0.1

var _buffer_time: float
var _input_buffered := false
var _direction: Vector2

func enter() -> void:
	super.enter()
	var mouse_position := _player.get_local_mouse_position()
	_direction = mouse_position.normalized()
	_play_punch(_direction)
	
	
	
	
func update(delta: float) -> State:
	_buffer_time += delta
	
	if _buffer_time > TIME_TILL_BUFFER:
		if Input.is_action_just_pressed("interact"):
			_input_buffered = true
	
	if not _player.directional_animator.is_playing():
		if not _input_buffered:
			return PlayerCombatState.new(_direction)
		else:
			return PlayerPunchState.new() 
	
	return



func _play_punch(direction: Vector2) -> void:
	var rnd: float = randf()
	var anim := ""
	
	if rnd < 0.5:
		anim = "front_punch"
	else:
		anim = "back_punch"
	
	_player.directional_animator.play_directional(anim, direction)
