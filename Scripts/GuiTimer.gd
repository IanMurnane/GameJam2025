extends CanvasLayer

@onready var timer_label: Label = $Label
@onready var countdown_timer: Timer = $Timer

# A reference to the player node. You'll need to set this.
@onready var player_node: Node3D = get_parent().get_node("Player")

var total_time_seconds = 70 # Set the total time to 60 seconds.
var player_x_threshold = 8.0 # The x-position to trigger the timer.
var label_visible: bool = false # Tracks whether label is currently shown

func _ready() -> void:
    # Set the initial state of the timer and label.
    countdown_timer.wait_time = total_time_seconds
    countdown_timer.one_shot = true # The timer will stop when it finishes.
    countdown_timer.timeout.connect(on_countdown_timeout)
    
    # Start hidden
    timer_label.modulate = Color(1, 1, 1, 0)
    timer_label.visible = false

func _process(_delta: float) -> void:
    if not is_instance_valid(player_node):
        print("player node not found")
        return

    # Check if the player is past the threshold
    if player_node.global_position.x > player_x_threshold:
        if not label_visible:
            # Only trigger once
            label_visible = true
            countdown_timer.start()
            fade_in_label()
        
        # Update the timer display while active
        var time_remaining = int(countdown_timer.time_left)
        timer_label.text = str(time_remaining)
    else:
        if label_visible:
            # Only trigger once
            label_visible = false
            countdown_timer.stop()
            countdown_timer.wait_time = total_time_seconds
            fade_out_label()

func fade_in_label() -> void:
    timer_label.visible = true
    timer_label.modulate.a = 0.0
    var tween = create_tween()
    tween.tween_property(timer_label, "modulate:a", 1.0, 0.4)

func fade_out_label() -> void:
    var tween = create_tween()
    tween.tween_property(timer_label, "modulate:a", 0.0, 0.4)
    tween.finished.connect(
        func():
            if not label_visible: # ensure player hasn't come back
                timer_label.visible = false
    )

func on_countdown_timeout() -> void:
    print("Time's up!")
    EventBus.out_of_time.emit()
