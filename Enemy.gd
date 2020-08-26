extends KinematicBody


const FLOOR_NORMAL := Vector3.UP

export var speed := 10.0
export var rotation_speed_factor := 3.0
export var accel := 4.0
export var deaccel = 4.5
export var lookRayLength := 4.0

var velocity := Vector3()

onready var PlayerDetectorRay := $DetectRay

func _ready() -> void:
	PlayerDetectorRay.cast_to = Vector3(0, 0, -lookRayLength)


func _physics_process(delta: float) -> void:
	var targetPoint : Transform
	var detectedPlayer : bool = PlayerDetectorRay.is_colliding()
	
	if detectedPlayer:
		targetPoint = get_tree().get_nodes_in_group('player')[0].transform		
	else:
		targetPoint = transform
	
#	Rotate the player
	look_at(targetPoint.origin, Vector3.UP)
	
	var targetVelocity := -transform.basis.z * speed
#	Smooth motion
	velocity = velocity.linear_interpolate(targetVelocity, accel * delta)
	if transform.origin.distance_to(targetPoint.origin) < 0.5:
		velocity = Vector3()
	
	velocity = move_and_slide(velocity)
#
