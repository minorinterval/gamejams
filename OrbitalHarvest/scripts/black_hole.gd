extends Area2D
@onready var path_follow: PathFollow2D = $".."

@export var movement_speed = 100

@onready var black_hole: Node2D = $"."
@export var rotation_speed : float = 800.0

func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
	path_follow.progress += movement_speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.oh_no()
