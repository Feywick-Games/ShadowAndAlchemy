class_name PlayerCombatState
extends State

var _player: Player
var _direction: Vector2

func enter() -> void:
	_player = state_machine.state_owner as Player

func update(_delta: float) -> State:
	if Input.is_action_just_pressed("cast"):
		return PlayerWindBlastState.new()
	elif Input.is_action_just_pressed("interact") and not Input.is_action_just_pressed("decompose"):
		pass
	elif Input.is_action_just_pressed("decompose"):
		return PlayerAbsorbBlastState.new()
	elif Input.is_action_just_pressed("cast_b"):
		return PlayerElectricBlastState.new()
	elif Input.is_action_just_pressed("cast_c"):
		return PlayerFireBlastState.new()
	elif Input.is_action_just_pressed("cast_d"):
		return PlayerWaterBlastState.new()
		
	_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_player.velocity = _direction * _player.speed
	return


func physics_update(_delta:float) -> State:
	_player.move_and_slide()
	
	_player.check_surfaces()
	
	return
