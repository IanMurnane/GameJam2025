extends CharacterBody3D

@onready var animation_player = $SuitMan/AnimationPlayer
@onready var suit_man_pivot = $SuitMan
@onready var collision = $Collision
@onready var collisionJump = $CollisionJump
@onready var collisionDouble = $CollisionDouble
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready var game_started = true


# Define player states as an enum for clarity.
enum PlayerState {
  INIT,
  IDLE,
  RUNNING,
  JUMPING,
  DOUBLE_JUMPING,
  ANGRY,
}

var current_state = PlayerState.INIT
var speed = 5.0 # Player's movement speed
var reduced_speed = 1.2 # Speed reduction factor when needed
var jump_velocity = 10.0 # How high the player jumps
var reduced_jump_velocity = 1.5
var is_speed_reduced = false
var out_of_time = false

# New variable for smooth rotation
var target_y_rotation = 0.0
var rotation_speed = 8.0 # Adjust this value to control the speed of the turn

# Get the gravity from the project settings to be consistent.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
  await get_tree().create_timer(2.0).timeout
  animation_player.animation_finished.connect(on_animation_finished)
  set_state(PlayerState.IDLE)
  
  collisionJump.disabled = true
  collisionDouble.disabled = true

  EventBus.player_entered.connect(_on_player_entered)
  EventBus.player_exited.connect(_on_player_exited)
  EventBus.out_of_time.connect(_out_of_time)

func _out_of_time():
  set_state(PlayerState.ANGRY)
  out_of_time = true

func _on_player_entered():
  if game_started:
    # print("Player entered the area!")
    is_speed_reduced = true
    pass
  pass

func _on_player_exited():
  # print("Player exited the area!")
  is_speed_reduced = false
  pass

func _physics_process(delta: float) -> void:
  print("Player position:", global_position)
  if out_of_time:
    if current_state != PlayerState.ANGRY:
      global_position.y = 0
      set_state(PlayerState.ANGRY)
    if Input.is_action_just_pressed("Jump"):
      set_state(PlayerState.IDLE)
      global_position.x = 0
      global_position.y = 0
      out_of_time = false
    return
  
  # Add the gravity.
  if not is_on_floor():
    velocity.y -= gravity * delta

  # Handle jump and double jump logic
  if Input.is_action_just_pressed("Jump"):
    if is_on_floor():
      velocity.y = jump_velocity if not is_speed_reduced else reduced_jump_velocity
      set_state(PlayerState.JUMPING)
      audio_player.play()
    elif current_state == PlayerState.JUMPING:
      velocity.y = jump_velocity if not is_speed_reduced else reduced_jump_velocity
      set_state(PlayerState.DOUBLE_JUMPING)
    return # Prevent the rest of the movement code from running on jump input

  # Get the input direction and handle the movement/deceleration.
  var input_dir = Input.get_vector("Left", "Right", "ui_up", "ui_down")
  var direction = Vector3(input_dir.x, 0, 0).normalized()
  
  if direction:
    velocity.x = direction.x * (speed if not is_speed_reduced else reduced_speed)

    set_state(PlayerState.RUNNING)
    # Update the target rotation
    if input_dir.x > 0:
      target_y_rotation = deg_to_rad(90) # Face right
    elif input_dir.x < 0:
      target_y_rotation = deg_to_rad(-90) # Face left
  else:
    velocity.x = move_toward(velocity.x, 0, speed)
    # Only set to IDLE if the player is on the floor.
    if is_on_floor():
      set_state(PlayerState.IDLE)

  # Smoothly rotate the character towards the target rotation.
  suit_man_pivot.rotation.y = lerp_angle(suit_man_pivot.rotation.y, target_y_rotation, delta * rotation_speed)

  move_and_slide()
  
  # Limit movement
  global_position.x = max(-5.0, global_position.x)
  global_position.y = max(0.0, global_position.y)

func on_animation_finished(anim_name):
  if anim_name == "jump" or anim_name == "doubleJump":
    if velocity.x == 0:
      set_state(PlayerState.IDLE)
    else:
      set_state(PlayerState.RUNNING)
    return

  animation_player.play(anim_name)

func set_state(new_state: PlayerState) -> void:
  if current_state == new_state: return

  var is_jumping = animation_player.current_animation == "jump" or animation_player.current_animation == "doubleJump"
  var wants_to_jump = new_state == PlayerState.JUMPING or new_state == PlayerState.DOUBLE_JUMPING
  if is_jumping and not wants_to_jump: return

  current_state = new_state

  match current_state:
    PlayerState.IDLE:
      collision.disabled = false
      collisionJump.disabled = true
      collisionDouble.disabled = true
      animation_player.play("idle")
    PlayerState.RUNNING:
      collision.disabled = false
      collisionJump.disabled = true
      collisionDouble.disabled = true
      animation_player.play("run")
    PlayerState.JUMPING:
      collision.disabled = true
      collisionJump.disabled = false
      collisionDouble.disabled = true
      animation_player.play("jump")
    PlayerState.DOUBLE_JUMPING:
      collision.disabled = true
      collisionJump.disabled = true
      collisionDouble.disabled = false
      animation_player.play("doubleJump")
      animation_player.seek(0.5)
    PlayerState.ANGRY:
      collision.disabled = false
      collisionJump.disabled = true
      collisionDouble.disabled = true
      animation_player.play("angry")
