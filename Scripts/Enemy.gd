extends KinematicBody
class_name Enemy

# Basic enemy agent

const FLOOR_NORMAL := Vector3.UP

export(NodePath) var camera
export var speed := 10.0
export var rotation_speed_factor := 3.0
export var accel := 4.0
export var deaccel := 3.5
export var detectRadius := 10.0
export var viewAngle = 60.0
export var on_collision_force := 1.5
export var health := 50.0 setget _health_changed

var velocity := Vector3()
var path := []
var path_index := 0

var mousePointIn3D : Vector3
var detected_color := Color(231, 34, 34)

onready var debug := $Debug
onready var spotLight := $SpotLight
onready var nav := get_parent()
onready var object_detect_ray := $ObjectDetect
onready var projectile_detector := $ProjectileDetector

var blood_particle := preload("res://Scenes/BloodParticle.tscn")

func _ready() -> void:
	camera = get_node(camera)
	spotLight.spot_angle = viewAngle

func _physics_process(delta: float) -> void:
#	Player transform
	var targetPoint : Transform
	targetPoint = get_tree().get_nodes_in_group('player')[0].transform	
	
	if canSeePlayer(targetPoint):
		move(delta, targetPoint)
	
# Detect the player
func canSeePlayer(playerTransform: Transform) -> bool:
	var enemyFoward : Vector3 = -transform.basis.z
	var playerToEnemy : Vector3 = (playerTransform.origin - transform.origin).normalized() 	
	var playerToEnemyDist : float = playerTransform.origin.distance_to(transform.origin)
	var rayCastPos : Transform = get_tree().get_nodes_in_group('player')[0].global_transform
		
#	Enemy view radius 
	if enemyFoward.angle_to(playerToEnemy) < deg2rad(viewAngle) and playerToEnemyDist < detectRadius:
#		Cast a ray to see if any obstacle is blocking the view from the player
		var space := get_world().get_direct_space_state()
		var result := space.intersect_ray(global_transform.origin, rayCastPos.origin, [self], collision_mask)
		if result.collider is Player:
			spotLight.light_color = Color.red
			return true
		else:
			spotLight.light_color = Color.white
		
	return false
		
# Main movement code (Dumb)
func move(delta: float, targetPoint: Transform) -> void:
	#	Rotate the player
		look_at(targetPoint.origin, Vector3.UP)
		
		var targetVelocity := -transform.basis.z * speed
	#	Smooth motion
		velocity = velocity.linear_interpolate(targetVelocity, accel * delta)
		if transform.origin.distance_to(targetPoint.origin) < 0.9:
			velocity = velocity.linear_interpolate(Vector3(), deaccel * delta)
		
		velocity = velocity.linear_interpolate(Vector3(), deaccel * delta)
		velocity += steer_away()
		velocity = move_and_slide(velocity, FLOOR_NORMAL)


func steer_away() -> Vector3:
	if object_detect_ray.is_colliding():
		var collision_normal = object_detect_ray.get_collision_normal()
		var steering = collision_normal
		steering = steering * on_collision_force
		return steering
	else:
		return Vector3()	
	



# With navmesh implemented
#func move(delta: float, targetPoint: Transform) -> void:
#	if path_index < path.size():
#
#	#	Rotate the player
#		look_at(path[path_index].normalized(), Vector3.UP)
#
#
#		var move_vec : Vector3 = (path[path_index] - global_transform.origin) 
#
#		print(targetPoint.origin)
#		if global_transform.origin.distance_to(path[path_index]) < 0.1:
#			path_index += 1
#		else:
#			var targetVelocity := -transform.basis.z * speed
##
##			velocity = velocity.linear_interpolate(targetVelocity, accel * delta)
##			if transform.origin.distance_to(targetPoint.origin) < 0.5:
##				velocity = Vector3()
#
##			velocity = targetVelocity
#
#			velocity = move_and_slide(targetVelocity, FLOOR_NORMAL)
#
#
#
#func get_nav(targetPoint: Vector3) -> void:
#	path = nav.get_simple_path(global_transform.origin, targetPoint)
#	path_index = 0
#
#func _process(delta: float) -> void:
#	if Input.is_action_just_pressed("shoot"):
#		var mousePosition = get_viewport().get_mouse_position()
#		var groundPlane  = Plane(Vector3.UP, 0)
#	#	Shoots a ray from the 2D plane to the 3D plane 
#		var point = groundPlane.intersects_ray(camera.project_ray_origin(mousePosition),camera.project_ray_normal(mousePosition))
#	#	Adjusted the y-axis value so the player dont look down
#		var heightCorrectedPoint = Vector3(point.x, transform.origin.y, point.z)
#		mousePointIn3D = heightCorrectedPoint
#		get_nav(mousePointIn3D)

func die() -> void:
	var blood_particle_ins = blood_particle.instance()
	var root_node = get_tree().get_root()
	root_node.add_child(blood_particle_ins)
	blood_particle_ins.global_transform.origin = transform.origin
	blood_particle_ins.emitting = true
#	yield(get_tree().create_timer(1.9), "timeout")
	queue_free()

func _health_changed(value: float) -> void:
	health = value
	if health <= 0:
		die()


func _on_ProjectileDetector_area_entered(area: Area) -> void:
	print(health)
	if area is Projectile:
		self.health -= area.damage
