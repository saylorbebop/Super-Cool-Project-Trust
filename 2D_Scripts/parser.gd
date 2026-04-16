extends Node2D
class_name Parser

func load_file(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		return {}
	var file:= FileAccess.open(file_path, FileAccess.READ)
	var json:= JSON.new()
	var json_str:= file.get_as_text()
	var error = json.parse(json_str)
	if error != OK:
		return {}
	file.close()
	return json.data

func load_dialogue_json(dialogue_section_name: String) -> Array:
	var dialogue_json: Dictionary = load_file("res://json_files/sample.json")
	if not dialogue_json:
		return []
	return dialogue_json.get(dialogue_section_name, [])
	
func _ready() -> void:
	print(load_dialogue_json("2")) 
