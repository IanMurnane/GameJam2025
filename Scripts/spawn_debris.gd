extends Node3D

@onready var audio_player: AudioStreamPlayer3D = $AnnounceAudio

const JSON_PATH := "res://Scenes/debris_spawn.json"

var can_play_sound = true

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


func _on_body_entered_announcement(body: Node3D) -> void:
    # Check if the entered body is the player and the sound is not currently playing.
    if body.is_in_group("player") and can_play_sound:
        audio_player.play()
        # Set the flag to false to prevent the sound from re-triggering immediately.
        can_play_sound = false

func _on_body_exited_announcement(body: Node3D) -> void:
    # When the player leaves the area, reset the flag so the sound can be played again.
    if body.is_in_group("player"):
        can_play_sound = true

func _on_finished(body: Node3D) -> void:
    EventBus.player_entered.emit()
