extends Spatial


#export(NodePath) var muzzle
export(PackedScene) var projectile
export(float, 0.0, 1.0) var timeBetweenShots = 0.2
export var projectileSpeed := 5.0
export var projectile_damage := 35.0

var muzzlePosition : Transform

onready var muzzle := $Muzzle
onready var shotTimer := $TimeBetweenShots

func _ready() -> void:
	shotTimer.wait_time = timeBetweenShots 


func shoot() -> void:
	muzzlePosition = muzzle.global_transform
	
	if shotTimer.is_stopped():
		var projectileInstance : Area = projectile.instance()
		projectileInstance.initialize(projectileSpeed, projectile_damage)
		add_child(projectileInstance)
		projectileInstance.global_transform = muzzlePosition
		shotTimer.start()
	
	
		
	

