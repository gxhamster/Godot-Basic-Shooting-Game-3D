extends Spatial

export var spawn_rate := 2
export(PackedScene) var enemy_scene


var spawn_position_array := []
var max_distance := 10.0

onready var spawn_timer := $SpawnTimer

func _ready() -> void:
	for spawn_pos in get_children():
		if spawn_pos is Position3D:
			 spawn_position_array.append(spawn_pos.global_transform.origin)
			
	spawn_timer.wait_time = spawn_rate
	spawn_timer.start()



func spawn_enemy() -> void:
	var enemy_instance : KinematicBody = enemy_scene.instance()
	var player_position : Vector3 = get_tree().get_nodes_in_group("player")[0].global_transform.origin 
	var nearestSpawnToPlayerDist := 100000
	var nearestSpawnToPlayer := Vector3()
	
# 	Find the spawn closest to player
	for i in spawn_position_array:
		var distance_to_player := player_position.distance_to(i)
		if  distance_to_player < nearestSpawnToPlayerDist:
			nearestSpawnToPlayer = i
			nearestSpawnToPlayerDist = player_position.distance_to(i)
	
#	If the distance of player is bigger than max_distance then dont spawn
	if nearestSpawnToPlayerDist > max_distance:
		return	
	else:
		add_child(enemy_instance)
#		enemy_instance.global_transform.looking_at(player_position, Vector3.UP)
		enemy_instance.global_transform.origin = nearestSpawnToPlayer
		


func _on_SpawnTimer_timeout() -> void:
	print("Time")
	spawn_enemy()
