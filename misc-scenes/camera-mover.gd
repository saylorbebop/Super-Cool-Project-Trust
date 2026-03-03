## Add the following children to make it work:
## |--Areas                              
## |--|--Area3D_1                             
## |--|--Area3D_2...     # as many as needed
## |--Dummy              # should be a Node3D or smth
extends Node3D

@onready var children := get_children()
var areas_child: Node
var dummy_child: Node
@export var origin_point_globals: Node

func move_camera_now(_area) -> void:
	origin_point_globals.move_camera_to_dummy(dummy_child)

func _ready() -> void:
	for i in children:
		print_debug(i.name)
		match i.name:
			"Areas":
				areas_child = i
			"Dummy":
				dummy_child = i
	print_debug("Areas child: %s, dummy child: %s" % [areas_child, dummy_child])
	var areas: Array[Node] = areas_child.get_children()
	for i in areas:
		i.body_entered.connect(move_camera_now)
