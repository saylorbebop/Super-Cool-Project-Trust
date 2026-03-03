## To use, fill the @export-ed variables properly!
extends Node3D

@export var area: Area3D
@export var dummy_child: Node

func move_camera_now(_area) -> void:
	Global.move_camera_to_dummy(dummy_child)

func _ready() -> void:
	area.body_entered.connect(move_camera_now)
