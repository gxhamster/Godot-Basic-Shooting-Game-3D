tool
extends Node
class_name DebugDraw


var points := Array()

onready var p1 = $point
onready var p2 = $point2
onready var p3 = $point3
onready var ig := $Draw
	
func _process(delta: float) -> void:
	points.clear()
	
	points.append(p1.transform.origin)
	points.append(p2.transform.origin)
	points.append(p3.transform.origin)
	
	ig.clear()
	ig.begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	for point in points:
		ig.add_vertex(point)
	
	ig.end()
	points.clear()

		

	
