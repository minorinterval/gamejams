extends RigidBody2D

@onready var asteroid: RigidBody2D = $"."

@onready var camera: Camera3D = $TextureRect/SubViewport/Camera3D
#@onready var player: CharacterBody2D = $Player1

@export var chain_reaction_radius = 400.0
@export var chain_reaction_length = 4
@export var chain_force_factor = 0.25

#should probably find the center, not hard code it (see also starfield.gd)
@export var center = Vector2(1000,600)

var vel = Vector2(0,0)

func _ready():
	asteroid.add_to_group("Asteroids")
	
	#asteroid.material.set_shader_parameter("alpha",0.0)
	
	# asteroids spawn anywhere in the middle. 
	# get the spawn area from the level size instead of hardcoding
	var wiggle = Vector2(randi()%1200 - 600 , randi()%1000 - 500)	
	global_position = center + wiggle
	
	# asteroids start with slow drift in a random direction
	var direction = Vector2(randf_range(-1.0,1.0),randf_range(-1.0,1.0))
	apply_central_impulse(direction*10)
	#var tween = asteroid.create_tween();
	#tween.tween_property(get_material(),"shader_parameter/alpha",1.0,2.0)
	

func _on_body_entered(body: Node2D) -> void:
	pass

func _physics_process(delta):
	move_and_collide(vel * delta)

func shockwave2(type,direction,force,num):
	apply_central_impulse(type*direction*force)
	
	if num < chain_reaction_length:
		num += 1
		for asteroid in get_tree().get_nodes_in_group("Asteroids"):
			var distance = asteroid.global_position.distance_to(global_position)
			if (distance > 1 && distance < chain_reaction_radius):
				var direction2 = global_position.direction_to(asteroid.global_position)
				var force2 = chain_force_factor * force * (1.0 - (distance / chain_reaction_radius))
				asteroid.shockwave2(type,direction2,force2,num)
