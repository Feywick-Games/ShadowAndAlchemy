class_name PlayerCombatState
extends State

var _player: Player
var _direction: Vector2

func enter() -> void:
	_player = state_machine.state_owner as Player

func update(_delta: float) -> State:
	if Input.is_action_just_pressed("cast"):
		var mouse_pos: Vector2 = _player.get_global_mouse_position()
		var direction = (mouse_pos - _player.global_position).normalized()
		_player.cast_effect(direction, _player.WIND_BLAST_SCENE.instantiate())
	if Input.is_action_just_released("cast"):
		_player.active_surface = null
	
	_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_player.velocity = _direction * _player.speed
	return


func physics_update(_delta:float) -> State:
	_player.move_and_slide()
	
	_player.check_surfaces()
	
	return
