extends CharacterBody2D

@onready var start_position1: Node2D = $"../StartPosition1"
@onready var start_position2: Node2D = $"../StartPosition2"
@onready var player: CharacterBody2D = $"."
@onready var ship: Sprite2D = $ship
@onready var jetfire_center: Node2D = $ship/Jetfire_Center
@onready var jetfire_l: Node2D = $ship/Jetfire_L
@onready var jetfire_r: Node2D = $ship/Jetfire_R
@onready var jetfire_l_side: Node2D = $ship/Jetfire_L_side
@onready var jetfire_r_side: Node2D = $ship/Jetfire_R_side
@onready var jet_light: PointLight2D = $ship/JetLight
@onready var jetfire_center_flame: Node2D = $ship/Jetfire_Center/Sprite2D
@onready var jetfire_l_flame: Node2D = $ship/Jetfire_L/Sprite2D
@onready var jetfire_r_flame: Node2D = $ship/Jetfire_R/Sprite2D
@onready var jetfire_l_side_flame: Node2D = $ship/Jetfire_L_side/Sprite2D
@onready var jetfire_r_side_flame: Node2D = $ship/Jetfire_R_side/Sprite2D

@onready var Shockwave: Sprite2D = $ship/Shockwave

@export var player_id = 1
@export var top_speed : float = 1000.0
@export var accel_rate : float = 6.0
@export var rot_speed : float = 6.0
@export var shockwave_radius : float = 400.0
@export var shockwave_strengh : float = 100.0

var vel := Vector2(0,0)
var move_angle : float = 0.0
var acceleration := Vector2(0,0)
var accel_angle : float = 0.0
var is_active : bool = true
var base_color
var edge_color

func _ready():
	Shockwave.visible = false
	
	#set jet light color per ship
	var base_color_1 = [0,1,1,1]
	var edge_color_1 = [0,0,1,1]
	var base_color_2 = [1.0,0.25,0.0,1.0]
	var edge_color_2 = [1.0,0.0,0.0,1.0]

	if player_id == 1:
		base_color = base_color_1
		edge_color = edge_color_1
		jet_light.set_color("00ffff")
	elif player_id == 2:
		base_color = base_color_2
		edge_color = edge_color_2
		jet_light.set_color("ff0000")
	
	jetfire_center_flame.material.set_shader_parameter("base_color",base_color)
	jetfire_center_flame.material.set_shader_parameter("edge_color",edge_color)
	jetfire_l_flame.material.set_shader_parameter("base_color",base_color)
	jetfire_l_flame.material.set_shader_parameter("edge_color",edge_color)
	jetfire_r_flame.material.set_shader_parameter("base_color",base_color)
	jetfire_r_flame.material.set_shader_parameter("edge_color",edge_color)
	jetfire_l_side_flame.material.set_shader_parameter("base_color",base_color)
	jetfire_l_side_flame.material.set_shader_parameter("edge_color",edge_color)
	jetfire_r_side_flame.material.set_shader_parameter("base_color",base_color)
	jetfire_r_side_flame.material.set_shader_parameter("edge_color",edge_color)
		
	reset_ship(player_id)

func _process(delta):
	pass

func _physics_process(delta):
	if not is_active: return
	move_angle = vel.angle()
	acceleration = Vector2(0,0)
	jetfire_center.modulate.a = 0;
	jetfire_l.modulate.a = 0;
	jetfire_r.modulate.a = 0;
	jetfire_l_side.modulate.a = 0;
	jetfire_r_side.modulate.a = 0;
	
	if Input.is_action_pressed("move_up_%s" % [player_id]):
		vel.y -= accel_rate
		acceleration = Vector2(0,-1)
	elif Input.is_action_pressed("move_down_%s" % [player_id]):
		vel.y += accel_rate
		acceleration = Vector2(0,1)
	if Input.is_action_pressed("move_left_%s" % [player_id]):
		vel.x -= accel_rate
		acceleration = Vector2(-1,0)
	elif Input.is_action_pressed("move_right_%s" % [player_id]):
		vel.x += accel_rate
		acceleration = Vector2(1,0)
	if (Input.is_action_pressed("move_up_%s" % [player_id]) && Input.is_action_pressed("move_left_%s" % [player_id])):
		acceleration = Vector2(-1,-1)
	elif (Input.is_action_pressed("move_up_%s" % [player_id]) && Input.is_action_pressed("move_right_%s" % [player_id])):
		acceleration = Vector2(1,-1)
	elif (Input.is_action_pressed("move_down_%s" % [player_id]) && Input.is_action_pressed("move_left_%s" % [player_id])):
		acceleration = Vector2(-1,1)
	elif (Input.is_action_pressed("move_down_%s" % [player_id]) && Input.is_action_pressed("move_right_%s" % [player_id])):
		acceleration = Vector2(1,1)
	if Input.is_action_just_pressed("attractor_%s" % [player_id]):
		shockwave(-1)
	if Input.is_action_just_pressed("repulsor_%s" % [player_id]):
		shockwave(1)
	
	# Acceleration is only used for rotating the ship in that direction,
	# not for actually moving in that direction. I see no need to simulate 
	# engine thrust vectors. This looks good enough.
	accel_angle = acceleration.angle()
	
	if here_we_go():
		#rotate and fire jets only during user input
		jetfire_center.modulate.a = 255;
		jet_light.enabled = true
		rotate_to_target(acceleration,delta)
	else:
		jetfire_center.modulate.a = 0;
		jetfire_l.modulate.a = 0;
		jetfire_r.modulate.a = 0;
		jetfire_l_side.modulate.a = 0;
		jetfire_r_side.modulate.a = 0;
		jet_light.enabled = false
	
	# limit speed for sanity
	if vel.length() > top_speed:
		vel = vel.normalized() * top_speed
	
	#update position
	position += vel * delta
	
	# stay within bounds
	var viewrect := get_viewport_rect()
	var ship_size = Vector2(
		ship.texture.get_width(), 
		ship.texture.get_height()) * ship.scale
	position.x = clamp(position.x,ship_size.x/2,viewrect.size.x-ship_size.x/2)
	position.y = clamp(position.y,ship_size.y/2,viewrect.size.y-ship_size.y/2)
	
	# if at a boundary, set the relevant velocity component to 0
	if position.x < (1+ship_size.x/2): vel.x = 0
	elif position.x > viewrect.size.x-(1+ship_size.x/2): vel.x = 0
	if position.y < (1+ship_size.y/2): vel.y = 0
	elif position.y > viewrect.size.y-(1+ship_size.y/2): vel.y = 0

func rotate_to_target(target,delta):
	var angle_to = ship.transform.x.angle_to(target) + 1.5707
	ship.rotate(sign(angle_to) * min(delta * rot_speed, abs(angle_to)))
	
	# fire the appropriate jets for the rotation (just for effect)
	if angle_to > 0.1:
		jetfire_l.modulate.a = 255;
		jetfire_l_side.modulate.a = 255;
		jetfire_r.modulate.a = 0;
		jetfire_r_side.modulate.a = 0;
	elif angle_to < -0.1:
		jetfire_l.modulate.a = 0;
		jetfire_l_side.modulate.a = 0;
		jetfire_r.modulate.a = 255;
		jetfire_r_side.modulate.a = 255;
	else:
		jetfire_r.modulate.a = 255;
		jetfire_l.modulate.a = 255;

func here_we_go():
	if (Input.is_action_pressed("move_left_%s" % [player_id]) or
		Input.is_action_pressed("move_right_%s" % [player_id]) or
		Input.is_action_pressed("move_up_%s" % [player_id]) or
		Input.is_action_pressed("move_down_%s" % [player_id])):
			return true
	else: return false

func oh_no():
	player.visible = false
	is_active = false
	await get_tree().create_timer(1).timeout
	reset_ship(player_id)
	
func reset_ship(player_id):
	var start_positions = [start_position1,start_position2]
	player.global_position = start_positions[player_id-1].global_position
	ship.global_rotation = 0
	vel = Vector2(0,0)
	
	#start with all engines off
	jetfire_center.modulate.a = 0;
	jetfire_l.modulate.a = 0;
	jetfire_r.modulate.a = 0;
	jetfire_l_side.modulate.a = 0;
	jetfire_r_side.modulate.a = 0;
	jet_light.enabled = false
	
	player.visible = true
	await get_tree().create_timer(0.14).timeout
	player.visible = false
	await get_tree().create_timer(0.14).timeout
	player.visible = true
	await get_tree().create_timer(0.14).timeout
	player.visible = false
	await get_tree().create_timer(0.14).timeout
	player.visible = true
	is_active = true

func shockwave(type):
	var init_size = 0.3
	var final_size = 0.0
	var duration = 0.35
	if type == 1:
		init_size = 0.0
		final_size = 0.3
	
	# set shockwave center to ship position
	Shockwave.material.set_shader_parameter("global_position",get_global_transform().origin)
	# trigger shockwave animation
	Shockwave.material.set_shader_parameter("size",init_size)
	Shockwave.visible = true
	var tween = Shockwave.create_tween();
	tween.tween_property(Shockwave.get_material(),"shader_parameter/size",final_size,duration)
	tween.connect("finished", func _reset():Shockwave.visible = false)
	
	#find asteroids within radius
	for asteroid in get_tree().get_nodes_in_group("Asteroids"):
		var distance = asteroid.global_position.distance_to(global_position)
		if distance < shockwave_radius:
			var direction = global_position.direction_to(asteroid.global_position)
			var force = shockwave_strengh * (1.0 - (distance / shockwave_radius))
			asteroid.shockwave2(type,direction,force,1)
