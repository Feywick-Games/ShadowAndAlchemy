class_name Player
extends Character

@export 
var character_identifier: String
@export
var cast_state: GDScript

# TODO: convert to constants
@onready
var WATER_BLAST_SCENE: PackedScene = load("res://Scene/Effect/_PackedScene/water_blast.tscn")
@onready
var ABSORB_BLAST_SCENE: PackedScene = load("res://Scene/Character/PlayerCharacter/_PackedScene/absorb_blast.tscn")
@onready
var ELECTRIC_BLAST_SCENE: PackedScene = load("res://Scene/Effect/_PackedScene/electric_blast.tscn")
@onready
var FIRE_BLAST_SCENE: PackedScene = load("res://Scene/Effect/_PackedScene/fire_blast.tscn")
@onready
var WIND_BLAST_SCENE: PackedScene = load("res://Scene/Effect/_PackedScene/wind_blast.tscn")


func _ready() -> void:
	super._ready()
	GameState.add_player(character_identifier, self)
