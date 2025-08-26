extends Camera3D

var player: Node3D
@export var deadzone_width = 3.0 # Width of the center zone
@export var deadzone_offset = 1.0 # A positive value shifts it left, negative shifts it right
@export var lerp_speed = 5.0 # How quickly the camera follows the player

var camera_target_position: Vector3

func _ready() -> void:
    player = get_parent().get_node("Player")

    if not is_instance_valid(player):
        print("Cant find player")
        return

    # Initialize the camera's target position at the player's starting position
    camera_target_position = player.global_position
    #global_position = camera_target_position

func _process(delta: float) -> void:
    if not is_instance_valid(player):
        return

    # 1. Determine the camera's target X position
    var player_x = player.global_position.x
    var camera_x = global_position.x

    # Calculate the left and right boundaries of the dead zone
    # The deadzone_offset shifts the entire zone
    var deadzone_left_x = camera_x - (deadzone_width / 2.0) - deadzone_offset
    var deadzone_right_x = camera_x + (deadzone_width / 2.0) - deadzone_offset
    
    # If the player is outside the dead zone, update the camera's target
    if player_x < deadzone_left_x:
        camera_target_position.x = player_x + (deadzone_width / 2.0) + deadzone_offset
    elif player_x > deadzone_right_x:
        camera_target_position.x = player_x - (deadzone_width / 2.0) + deadzone_offset

    # 2. Smoothly move the camera towards the target position
    global_position.x = lerp(camera_x, camera_target_position.x, delta * lerp_speed)
