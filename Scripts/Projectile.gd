extends Area
class_name Projectile

var speed : float
var damage : float
var deviation : float

var velocity = Vector3()

func _ready() -> void:
	set_as_toplevel(true)

func initialize(_speed: float, _damage: float) -> void:
	speed = _speed
	damage = _damage


func _physics_process(delta: float) -> void:
	velocity = Vector3.FORWARD * speed * delta
	velocity.x += rand_range(-1, 1) * deviation
	
	transform = transform.translated(velocity) 



func _on_Projectile_body_entered(body: Node) -> void:
	queue_free()
