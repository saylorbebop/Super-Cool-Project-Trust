## To use, fill the @export-ed variables properly!
extends Node3D

## MUST BE ON MASK 2 ONLY!
@export var area: Area3D
## A marker that the camera will instantly teleport to
@export var dummy_child: Marker3D

func move_camera_now(_entered) -> void:
	print_debug("Signal fired! The body that entered is: ", _entered.name)
	Global.move_camera_to_dummy(dummy_child)

func _ready() -> void:
	area.body_entered.connect(move_camera_now)
