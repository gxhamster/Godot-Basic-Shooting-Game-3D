extends KinematicBody

export(NodePath) var camera_path

var path = []
var path_index = 0
var speed = 50.0
var velocity = Vector3()
var FLOOR_NORMAL = Vector3.UP

var accel = 5.0
var turnSpeed = 0.005

var mousePointIn3D = Vector3()
var camera

onready var nav = get_parent()

func _ready() -> void:
	camera = get_node(camera_path)
	
	
func _physics_process(delta: float) -> void:
	move(delta, mousePointIn3D)

# With navmesh implemented
func move(delta: float, targetPoint: Vector3) -> void:
	if path_index < path.size():
		
	#	Rotate the player
		var lookAtVectorTarget = Vector3(path[path_index].x, global_transform.origin.y, path[path_index].z)
		var lookAtVector = global_transform.origin
		lookAtVector = lookAtVector.linear_interpolate(lookAtVectorTarget, turnSpeed * delta)
		look_at(lookAtVector, Vector3.UP)
		
	#	Fix the y-axis so the unit dont sink below
		path[path_index] = Vector3(path[path_index].x, global_transform.origin.y, path[path_index].z)
		
		var move_vec : Vector3 = (path[path_index] - global_transform.origin)
#		move_vec = Vector3(move_vec.x, global_transform.origin.y, move_vec.z) 

		
		if global_transform.origin.distance_to(path[path_index]) < 0.1:
			path_index += 1
		else:
			var targetVelocity = move_vec.normalized() * speed
			move_vec = move_vec.linear_interpolate(targetVelocity, accel * delta)
			velocity = move_and_slide(move_vec, FLOOR_NORMAL)

func get_nav(targetPoint: Vector3) -> void:
	path = nav.get_simple_path(global_transform.origin, targetPoint)
	path_index = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		var mousePosition = get_viewport().get_mouse_position()
		var groundPlane  = Plane(Vector3.UP, 0)
	#	Shoots a ray from the 2D plane to the 3D plane 
		var point = groundPlane.intersects_ray(camera.project_ray_origin(mousePosition),camera.project_ray_normal(mousePosition))
	#	Adjusted the y-axis value so the player dont look down
		var heightCorrectedPoint = Vector3(point.x, transform.origin.y, point.z)
		mousePointIn3D = heightCorrectedPoint
		get_nav(mousePointIn3D)
