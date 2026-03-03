extends Node3D

enum CharacterModel { DEFAULT }
@onready var CharacterModelMap: Dictionary[CharacterModel, StringName] = {
	CharacterModel.DEFAULT: "res://3D-assets/default-capsule.tscn"
}

func switch_to(char: CharacterModel) -> void:
	for i in get_children():
		i.queue_free()
	var new_child: Node = load(CharacterModelMap[char]).instantiate()
	add_child(new_child)
