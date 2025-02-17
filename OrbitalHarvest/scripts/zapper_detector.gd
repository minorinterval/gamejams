extends Area2D

const ZAPPER_SCENE = preload("res://Other scenes/zapper.tscn")
@onready var mining_dock: Area2D = $"../.."

var asteroids = []
var zappers = []
var color
var player_id

func _ready():
	player_id = mining_dock.player_id

func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Asteroids"):
		color = mining_dock.color
		start_zapping(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Asteroids"):
		var departing_asteroid_id = asteroids.find(body,0)
		var departing_asteroid = asteroids[asteroids.find(body,0)]
		
		# kill associated zappers
		if is_instance_valid(departing_asteroid):
			# left detection zone instead of actually disappearing
			departing_asteroid.get_zapped_by(zappers[departing_asteroid_id],0,player_id)
		zappers[departing_asteroid_id].queue_free()
		zappers.remove_at(departing_asteroid_id)
		asteroids.remove_at(departing_asteroid_id)

func start_zapping(asteroid):
	asteroids.append(asteroid)
	var zapper = ZAPPER_SCENE.instantiate()
	zapper.initialize(color,asteroid,player_id)
	add_child(zapper)
	zappers.append(zapper)
