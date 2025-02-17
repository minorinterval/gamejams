extends Node2D

@onready var zapper: Node2D = $"."
@onready var lightning: Line2D = $Lightning
@onready var sparks: GPUParticles2D = $Sparks
@onready var flare: GPUParticles2D = $Flare

var distance : float = 0.0
var impact_distance : float = 0.0
var impact_position = Vector2(0,0)
var asteroid
var color
var player_id

var lightning_ready = false
var sparks_ready = false
var flare_ready = false

func initialize(info,target,ID):
	asteroid = target
	color = info
	player_id = ID
	var zapper: Node2D = $"."
	asteroid.get_zapped_by(zapper,1,player_id) 
	# second argument 0 would be to stop zapping it
	
func _ready():
	pass

func _process(delta: float) -> void:
	zap(asteroid)

func zap(asteroid):
	if lightning_ready:
		lightning.default_color = color
		lightning_ready = false
	if sparks_ready:
		sparks.process_material.color = color
		sparks_ready = false
	if flare_ready:
		flare.process_material.color = color
		flare_ready = false
	
	if is_instance_valid(asteroid):
		distance = global_position.distance_to(asteroid.global_position)
		impact_distance = distance - asteroid.radius
		impact_position = global_position.lerp(asteroid.global_position, impact_distance/distance);
		
		# point the zapper graphics at the asteroid
		sparks.global_position = impact_position
		# I haven't properly calculated the sparks angle yet
		# sparks.global_rotation_degrees = get_angle_to(impact_position)
		flare.global_position = impact_position
		lightning.set_point_position(1,to_local(impact_position))

func _on_lightning_tree_entered():
	lightning_ready = true

func _on_sparks_tree_entered():
	sparks_ready = true

func _on_flare_tree_entered():
	flare_ready = true
