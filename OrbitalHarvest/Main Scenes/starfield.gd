extends Sprite2D

@onready var player_1: CharacterBody2D = $"../Player1"

func _process(delta):
	global_position = Vector2(1000,600) - player_1.global_position/20
