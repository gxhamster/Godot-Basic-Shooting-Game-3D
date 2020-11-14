extends Node

# Handles equipping of guns to player (This does not define the gun)

export(PackedScene) var starting_gun 
export(Array, PackedScene) var guns := []

var guns_index := 0 
var current_gun

var equipped_gun  

func _ready() -> void:
	if starting_gun != null:
		change_gun(starting_gun)
	

func _process(delta: float) -> void:
	if guns.size() > 1:
		if Input.is_action_just_pressed("changed_gun"):
			cycle_guns()
	
	if Input.is_action_pressed("shoot") and equipped_gun != null:
		equipped_gun.shoot()

	
func cycle_guns() -> void:
	guns_index = (guns_index + 1) % guns.size()
	change_gun(guns[guns_index])	
	
	
# Equip gun
func change_gun(_gun: PackedScene) -> void:
	current_gun = _gun
	
	
	if get_children().size() > 0:
		var prev_gun = get_children()[0]
		remove_child(prev_gun)
	
	var gun_instance : Spatial = current_gun.instance()
	equipped_gun = gun_instance
	self.add_child(gun_instance)
	# gun_instance.global_transform.origin = Vector3.ZERO
