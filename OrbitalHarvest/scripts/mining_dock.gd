extends Area2D

@onready var gameplay: Node2D = $".."
@onready var docklight_mid: PointLight2D = $"Docklight Mid"
@onready var docklight_a: PointLight2D = $"Docklight A"
@onready var docklight_b: PointLight2D = $"Docklight B"
@onready var docklight_c: PointLight2D = $"Docklight C"

@onready var score_1_text: Label = $"../Score 1"
@onready var score_2_text: Label = $"../Score 2"

@export var player_id = 1
@export var rot_speed = 3
var score_1 = 0
var score_2 = 0

var color = 3;
@export var base_color_1 = "00ffff"
@export var base_color_2 = "ff0000"

func _ready():
	#start at a random orientation
	rotation_degrees = randi()%360
	
	#set colors per player
	if player_id == 1:
		color = base_color_1
	elif player_id == 2:
		color = base_color_2
	#"color" is also referenced from zapper_detector
	
	docklight_mid.set_color(color)
	docklight_a.set_color(color)
	docklight_b.set_color(color)
	docklight_c.set_color(color)

func _process(delta):
	#spin slowly
	rotation_degrees += rot_speed * delta

func _on_body_entered(body):
	pass
	# maybe do something if a player flies thru?
