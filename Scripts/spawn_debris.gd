extends Node3D

const JSON_PATH := "res://Scenes/debris_spawn.json"

func _ready():
	spawn_debris_from_json()

func spawn_debris_from_json():
	var file = FileAccess.open(JSON_PATH, FileAccess.READ)
	if not file:
		push_error("Could not open debris_spawn.json")
		return

	var json_text = file.get_as_text()
	file.close()

	var result = JSON.parse_string(json_text)
	if typeof(result) != TYPE_DICTIONARY:
		push_error("Failed to parse debris_spawn.json")
		return

	var debris_list = result.get("debris", [])
	for debris in debris_list:
		var scene_name = debris.get("scene", "")
		var pos_val = debris.get("position", 0)
		if scene_name != "":
			var scene_path = "res://Scenes/Debris/%s.tscn" % scene_name
			var scene = load(scene_path)
			if scene:
				var debris_instance = scene.instantiate()
				# Use only the integer value for X, Y and Z are zero
				debris_instance.position = Vector3(int(pos_val), 0, 0)
				add_child(debris_instance)
