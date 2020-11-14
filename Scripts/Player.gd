extends KinematicBody
class_name Player

export(NodePath) var camera

const FLOOR_NORMAL := Vector3.UP

export var speed := 30.0
export var rotation_speed_factor := 3.0
export var accel := 4.5
export var deaccel = 4.3
export var health := 100.0 setget _player_health_changed

var blood_particle := preload("res://Scenes/BloodParticle.tscn")

var velocity := Vector3()
var mousePointIn3D: Vector3
var current_camera : Camera

onready var Gun := $Gun
onready var player_camera := $PlayerCamera


func _ready() -> void:
	camera = get_node(camera)

# Main physics frame
func _physics_process(delta: float) -> void:
	

	var direction = get_input_direction()
	
	rotate_player(delta)

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

func _player_health_changed(value: float):
	health = value
	if health <= 0:
		die()
		
func die() -> void:
	var blood_particle_ins = blood_particle.instance()
	var root_node = get_tree().get_root()
	root_node.add_child(blood_particle_ins)
	blood_particle_ins.global_transform.origin = transform.origin
	blood_particle_ins.emitting = true
	queue_free()


func _on_ProjectileDetector_area_entered(area: Area) -> void:
	if area is Projectile:
		self.health -= area.damage
