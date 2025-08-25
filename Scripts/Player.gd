extends CharacterBody3D

@onready var animation_player = $SuitMan/AnimationPlayer

func _ready():
    # Connect the "animation_finished" signal to a function in this script.
    animation_player.animation_finished.connect(on_animation_finished)
    
    # Play the "mixamo_com" animation when the scene starts.
    animation_player.play("Armature|mixamo_com|Layer0")

func on_animation_finished(anim_name):
    # This function will be called when an animation finishes.
    # It checks if the finished animation is the one we want to loop.
    if anim_name == "Armature|mixamo_com|Layer0":
        animation_player.play("Armature|mixamo_com|Layer0")
