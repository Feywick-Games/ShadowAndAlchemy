class_name PlayerCombatState
extends PlayerState

var _direction: Vector2


func _init(direction := Vector2.ZERO) -> void:
	_direction = direction


func enter() -> void:
	super.enter()
	_player.directional_animator.play_directional("combat_idle", _direction)


func update(_delta: float) -> State:
	if Input.is_action_just_pressed("cast"):
		return _player.cast_state.new(_direction)
	elif Input.is_action_just_pressed("interact") and not Input.is_action_just_pressed("decompose"):
		return PlayerPunchState.new()
	elif Input.is_action_just_pressed("decompose"):
		return PlayerAbsorbBlastState.new()

	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dir != _direction and dir != Vector2.ZERO:
		_player.directional_animator.play_directional("combat_idle", dir)
	
	_direction = dir 
	
	_player.velocity = _direction * _player.speed * Vector2(1,.75)
	return


func physics_update(_delta:float) -> State:
	_player.move_and_slide()
	_player.check_surfaces()
	return
