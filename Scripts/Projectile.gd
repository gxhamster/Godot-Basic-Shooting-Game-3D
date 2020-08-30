extends Area
class_name Projectile

var speed : float
var damage : float

func _ready() -> void:
	set_as_toplevel(true)

func initialize(_speed: float, _damage: float) -> void:
	speed = _speed
	damage = _damage


func _physics_process(delta: float) -> void:
	transform = transform.translated(Vector3.FORWARD * speed * delta ) 



func _on_Projectile_body_entered(body: Node) -> void:
	queue_free()
