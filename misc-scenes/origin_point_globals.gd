extends Node3D

func move_camera_to_dummy(dummy: Node) -> void:
	%Camera.make_current()
	%Camera.global_transform = dummy.global_transform
	
