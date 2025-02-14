extends Node2D

@export_range(1, 2) var player_number = 2
#someday maybe I'll use player_number in code instead of manually adding players

@onready var score_1_text: Label = $"Score 1"
@onready var score_2_text: Label = $"Score 2"
var score_1 = 0
var score_2 = 0

@export var asteroid_number = 11

@onready var gameplay: Node2D = $"."
const ASTEROID = preload("res://Other scenes/asteroid.tscn")

func _ready():
	for n in asteroid_number:
		gameplay.add_child(ASTEROID.instantiate())
	
	# set the score counters' colors
	score_1_text.modulate = Color(0,1,1,1)
	score_2_text.modulate = Color(1,0,0,1)
	
func _process(delta):
	pass

#if asteroids fly offscreen, replace them
func _on_area_2d_body_exited(body):
	if body.is_in_group("Asteroids"):
		await get_tree().create_timer(randi()%3+2).timeout
		gameplay.add_child(ASTEROID.instantiate())

func score(player_id):
#update scores
		if player_id == 1:
			score_1 += 1
		elif player_id == 2:
			score_2 += 1
		
		score_1_text.text = str(score_1)
		score_2_text.text = str(score_2)
