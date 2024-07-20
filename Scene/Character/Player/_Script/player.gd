class_name Player
extends Character

# TODO: convert to constants
@onready
var WIND_BLAST_SCENE: PackedScene = load("res://Scene/Effect/_PackedScene/water_blast.tscn")
@onready
var ABSORB_BLAST_SCENE: PackedScene = load("res://Scene/Character/Player/_PackedScene/absorb_blast.tscn")
@onready
var ELECTRIC_BLAST_SCENE: PackedScene = load("res://Scene/Effect/_PackedScene/electric_blast.tscn")
