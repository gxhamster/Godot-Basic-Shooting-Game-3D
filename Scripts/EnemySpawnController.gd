extends Spatial

# Handles spawning of enemies in scene

export var spawn_rate := 2
export(PackedScene) var enemy_scene
export(int, 1, 15) var max_enemies_per_scene = 15

var spawn_position_array := []
var max_distance := 10.0

onready var spawn_timer := $SpawnTimer

func _ready() -> void:
	for spawn_pos in get_children():
		if spawn_pos is Position3D:
			 spawn_position_array.append(spawn_pos)
			
	spawn_timer.wait_time = spawn_rate
	spawn_timer.start()



func spawn_enemy() -> void:
#	Dont spawn if no. of enemies exceed
	if get_tree().get_nodes_in_group("enemy").size() >= max_enemies_per_scene:
		return 
		
	var enemy_instance : KinematicBody = enemy_scene.instance()
	var player_position : Vector3 = get_tree().get_nodes_in_group("player")[0].global_transform.origin 
	var nearestSpawnToPlayerDist := 100000.0
	var nearestSpawnToPlayer := Transform()
	

# 	Find the spawn closest to player
	for i in spawn_position_array:
		var distance_to_player := player_position.distance_to(i.transform.origin)
		if  distance_to_player < nearestSpawnToPlayerDist:
			nearestSpawnToPlayer = i.transform
			nearestSpawnToPlayerDist = player_position.distance_to(i.transform.origin)
	
#	If the distance of player is bigger than max_distance then dont spawn
	if nearestSpawnToPlayerDist > max_distance:
		return	
	else:
		
		
		add_child(enemy_instance)
		
		enemy_instance.global_transform = nearestSpawnToPlayer
		
		
func _on_SpawnTimer_timeout() -> void:
	spawn_enemy()
