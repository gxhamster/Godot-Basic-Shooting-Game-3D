extends Area

var speed : float


func _ready() -> void:
	set_as_toplevel(true)

func initialize(_speed: float) -> void:
	speed = _speed


func _physics_process(delta: float) -> void:
	transform = transform.translated(Vector3.FORWARD * speed * delta ) 
