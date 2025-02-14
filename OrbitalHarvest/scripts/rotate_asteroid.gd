extends Node3D

# start with random spinning about the 3 axes
@export var speed: Vector3 = Vector3(randi() % 50,randi() % 50,randi() % 50)

func _process(delta):
	rotation_degrees += speed * delta
