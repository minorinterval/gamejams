extends RigidBody2D

@onready var camera: Camera3D = $TextureRect/SubViewport/Camera3D
@onready var player: CharacterBody2D = $"../Player"

var vel = Vector2(0,0)

func _on_body_entered(body: Node2D) -> void:
	pass

func _physics_process(delta):
	move_and_collide(vel * delta)

func shockwaved(direction,force):
	apply_central_impulse(direction*force)
