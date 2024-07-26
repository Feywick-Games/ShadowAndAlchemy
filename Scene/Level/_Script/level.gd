class_name Level
extends Node2D

@export
var _level_size: Vector2

func _ready() -> void:
	GameState.level_size = _level_size
	EventBus.level_loaded.emit()
