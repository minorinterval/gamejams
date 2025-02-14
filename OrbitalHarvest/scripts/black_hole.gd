extends Area2D
@onready var path_follow: PathFollow2D = $".."
@onready var black_hole: Node2D = $"."

@export var movement_speed = 0.002
@export var rotation_speed : float = 800.0

var direction = randi()%2 - 1 #-1,0,1

func _process(delta):
	rotation_degrees += rotation_speed * delta
	path_follow.progress_ratio += movement_speed * delta
	# should either go "clockwise" or the other way, or not at all

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.oh_no()
