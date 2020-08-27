extends KinematicBody


const FLOOR_NORMAL := Vector3.UP

export var speed := 10.0
export var rotation_speed_factor := 3.0
export var accel := 4.0
export var deaccel := 4.5
export var detectRadius := 10.0

var velocity := Vector3()


func _ready() -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
#	Player transform
	var targetPoint : Transform
	targetPoint = get_tree().get_nodes_in_group('player')[0].transform	
	
		
	if canSeePlayer(targetPoint):
		move(delta, targetPoint)
	
# Check Detect the player
func canSeePlayer(playerTransform: Transform) -> bool:
	var enemyFoward : Vector3 = -transform.basis.z
	var playerToEnemy : Vector3 = (playerTransform.origin - transform.origin).normalized() 	
	var playerToEnemyDist : float = playerTransform.origin.distance_to(transform.origin)
	
	if enemyFoward.dot(playerToEnemy) > 0 and playerToEnemyDist < detectRadius:
		return true

	return false
		
# Main movement code
func move(delta: float, targetPoint: Transform) -> void:
	#	Rotate the player
		look_at(targetPoint.origin, Vector3.UP)
		
		var targetVelocity := -transform.basis.z * speed
	#	Smooth motion
		velocity = velocity.linear_interpolate(targetVelocity, accel * delta)
		if transform.origin.distance_to(targetPoint.origin) < 0.5:
			velocity = Vector3()
	
		velocity = move_and_slide(velocity, FLOOR_NORMAL)
