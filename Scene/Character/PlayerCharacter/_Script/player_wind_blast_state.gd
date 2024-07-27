class_name PlayerWindBlastState
extends PlayerState

var _directional_animator: DirectionalAnimator
var particles: WindBlast

func enter() -> void:
	super.enter()
	var mouse_pos: Vector2 = _player.get_global_mouse_position()
	var direction = (mouse_pos - _player.global_position).normalized()
	particles = _player.WIND_BLAST_SCENE.instantiate()
	_player.cast_effect(direction, particles)
	
	_directional_animator = _player.get_node("DirectionalAnimator")
	_directional_animator.play("idle_down")


func update(_delta: float) -> State:
	if is_instance_valid(particles):
		var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		dir.y = 0
		if dir != Vector2.ZERO:
			particles.steer(dir)
	else:
		return PlayerCombatState.new()

	if Input.is_action_just_released("cast"):
		return PlayerCombatState.new()

	return
