extends Node3D

@onready var camera = %Camera

func move_camera_to_dummy(dummy: Node) -> void:
	%Camera.make_current()
	%Camera.global_transform = dummy.global_transform
	
