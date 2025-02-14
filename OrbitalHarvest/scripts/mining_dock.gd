extends Area2D

@onready var docklight_mid: PointLight2D = $"Docklight Mid"
@onready var docklight_a: PointLight2D = $"Docklight A"
@onready var docklight_b: PointLight2D = $"Docklight B"
@onready var docklight_c: PointLight2D = $"Docklight C"
@onready var lightning_a: Line2D = $"Docklight A/Lightning A"
@onready var sparks_a: GPUParticles2D = $"Docklight A/Sparks A"
@onready var flare_a: GPUParticles2D = $"Docklight A/Flare A"
@onready var lightning_b: Line2D = $"Docklight B/Lightning B"
@onready var sparks_b: GPUParticles2D = $"Docklight B/Sparks B"
@onready var flare_b: GPUParticles2D = $"Docklight B/Flare B"
@onready var lightning_c: Line2D = $"Docklight C/Lightning C"
@onready var sparks_c: GPUParticles2D = $"Docklight C/Sparks C"
@onready var flare_c: GPUParticles2D = $"Docklight C/Flare C"

@export var player_id = 1
@export var rot_speed = 3

@export var base_color_1 = "00ffff"
@export var base_color_2 = "ff0000"

var color = 0;
func _ready():
	#start at a random orientation
	rotation_degrees = randi()%360
	
	#set colors per player
	if player_id == 1:
		color = base_color_1
	elif player_id == 2:
		color = base_color_2
	docklight_mid.set_color(color)
	docklight_a.set_color(color)
	docklight_b.set_color(color)
	docklight_c.set_color(color)
	lightning_a.default_color = color
	lightning_b.default_color = color
	lightning_c.default_color = color
	sparks_a.process_material.color = color
	sparks_b.process_material.color = color
	sparks_c.process_material.color = color
	flare_a.process_material.color = color
	flare_b.process_material.color = color
	flare_c.process_material.color = color

func _process(delta):
	#spin slowly
	rotation_degrees += rot_speed * delta

func _on_body_entered(body):
	if body.is_in_group("Asteroids"):
		zap(body)
		print("Player ",player_id," scored!")
		
func zap(asteroid):
	asteroid.queue_free()
