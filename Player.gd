extends KinematicBody

export(NodePath) var camera

const FLOOR_NORMAL := Vector3.UP

export var speed := 30.0
export var rotation_speed_factor := 3.0
export var accel := 4.0
export var deaccel = 4.5

var velocity := Vector3()
var mousePointIn3D: Vector3

onready var Gun := $Gun

func _ready() -> void:
	camera = get_node(camera)

# Main physics frame
func _physics_process(delta: float) -> void:
	
	var direction = get_input_direction()
	
	rotate_player(delta)
	
	if Input.is_action_pressed("shoot"):
		Gun.shoot()
	
	var targetVelocity = direction * speed
	velocity = velocity.linear_interpolate(targetVelocity, accel * delta)
	velocity = velocity.linear_interpolate(Vector3(), deaccel * delta)
	velocity = move_and_slide(velocity)

# Player directional Input
func get_input_direction() -> Vector3:
	var _direction = Vector3()
	if Input.is_action_pressed("forward"):
		_direction -= transform.basis.z
	if Input.is_action_pressed("backward"):
		_direction += transform.basis.z
	
	_direction = _direction.normalized()
	return _direction

# Rotate the player 
func rotate_player(delta: float) -> void:
	var mousePosition = get_viewport().get_mouse_position()
	var groundPlane  = Plane(Vector3.UP, 0)
#	Shoots a ray from the 2D plane to the 3D plane 
	var point = groundPlane.intersects_ray(camera.project_ray_origin(mousePosition),camera.project_ray_normal(mousePosition))
#	Adjusted the y-axis value so the player dont look down
	var heightCorrectedPoint = Vector3(point.x, transform.origin.y, point.z)
	mousePointIn3D = heightCorrectedPoint
#	print(heightCorrectedPoint)
	
	var target_direction: = transform.looking_at(heightCorrectedPoint, Vector3.UP)
# Smooths rotation of player
	transform = transform.interpolate_with(target_direction, rotation_speed_factor * delta)	
