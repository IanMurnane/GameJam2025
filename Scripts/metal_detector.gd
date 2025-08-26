extends Node3D

# Get references to the nodes
@onready var area_detector: Area3D = $Area3D
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

# A boolean to prevent the sound from spamming if the player stands still.
var can_play_sound = true

#func _ready() -> void:
    # Connect the body_entered signal to our custom function.
    #area_detector.body_entered.connect(on_body_entered)
    # Also connect the body_exited signal to reset the flag.
    #area_detector.body_exited.connect(on_body_exited)

func on_body_entered(body: Node3D) -> void:
    print("body entered")
    # Check if the entered body is the player and the sound is not currently playing.
    if body.is_in_group("player") and can_play_sound:
        print("playing sound")
        audio_player.play()
        # Set the flag to false to prevent the sound from re-triggering immediately.
        can_play_sound = false
    else:
        print("cant play sound ", body.is_in_group("player"), " ", can_play_sound)

func on_body_exited(body: Node3D) -> void:
    print("body exited")
    # When the player leaves the area, reset the flag so the sound can be played again.
    if body.is_in_group("player"):
        can_play_sound = true
