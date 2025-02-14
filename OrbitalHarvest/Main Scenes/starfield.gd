extends Sprite2D

#should probably find the center, not hardcode it (see also asteroid.gd)
@export var center = Vector2(1000,600)

@onready var player_1: CharacterBody2D = $"../Player1"

func _process(delta):
	global_position = center - player_1.global_position/20
