extends Spatial
class_name Gun

#export(NodePath) var muzzle
export(PackedScene) var projectile
export(float, 0.0, 1.0) var timeBetweenShots := 0.2
export var projectileSpeed := 5.0
export var projectile_damage := 35.0
export var bullets_per_magazine := 50

var muzzlePosition : Transform
var bullet_amount := 0

onready var muzzle := $Muzzle
onready var shotTimer := $TimeBetweenShots

func _ready() -> void:
	shotTimer.wait_time = timeBetweenShots 
	bullet_amount = bullets_per_magazine



func shoot() -> void:
	muzzlePosition = muzzle.global_transform
	
	if shotTimer.is_stopped() and bullet_amount >= 0:
		var projectileInstance : Area = projectile.instance()
		projectileInstance.initialize(projectileSpeed, projectile_damage)
		add_child(projectileInstance)
		projectileInstance.global_transform = muzzlePosition
		bullet_amount -= 1
		shotTimer.start()
	
	
		
	

