extends Node

signal cam_follow_requested(leader: Node2D)
signal absorb_ended(area: AbsorbBlast)
signal item_absorbed(amount: float, player: Globals.PlayerCharacter)
signal level_loaded
