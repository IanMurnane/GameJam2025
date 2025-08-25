extends CharacterBody3D

@onready var animation_player = $SuitMan/AnimationPlayer

# Define player states as an enum for clarity.
enum PlayerState {
    IDLE,
    RUNNING,
    JUMPING,
    DOUBLE_JUMPING,
}

var current_state = PlayerState.IDLE

func _ready():
    # Connect the animation finished signal to handle state transitions.
    animation_player.animation_finished.connect(on_animation_finished)
    animation_player.play("idle")
    
func _physics_process(delta: float) -> void:
    # Handle jump and double jump logic
    if Input.is_action_just_pressed("Jump"):
        # Check if the player is in the JUMPING state to allow a double jump.
        if current_state == PlayerState.JUMPING:
            set_state(PlayerState.DOUBLE_JUMPING)
        # Otherwise, if the player is on the ground, allow a single jump.
        else:
            set_state(PlayerState.JUMPING)

func on_animation_finished(anim_name):
    # After a jump animation finishes, transition to the RUNNING state.
    # This assumes the player will move after landing.
    if anim_name == "jump" or anim_name == "doubleJump":
        set_state(PlayerState.RUNNING)

# New function to handle state transitions and play the corresponding animation.
func set_state(new_state: PlayerState) -> void:
    if current_state == new_state:
        return # Do nothing if we're already in this state.
    
    current_state = new_state
    
    # Play the animation based on the new state.
    match current_state:
        PlayerState.IDLE:
            animation_player.play("idle")
        PlayerState.RUNNING:
            animation_player.play("run")
        PlayerState.JUMPING:
            animation_player.play("jump")
        PlayerState.DOUBLE_JUMPING:
            animation_player.play("doubleJump")
            animation_player.seek(0.5)
