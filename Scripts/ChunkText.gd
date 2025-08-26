extends Node

# These booleans will be used to control the visibility from the Inspector.
@export var show_title: bool = false
@export var show_t_2_g_a: bool = false
@export var show_t_2_g_b: bool = false
@export var show_t_2_g_c: bool = false
@export var show_t_2_g_d: bool = false
@export var show_t_2_g_e: bool = false
@export var show_t_2_g_f: bool = false
@export var show_t_2_g_g: bool = false

# Dictionary to map exported variables to their corresponding node names.
var wall_parts: Dictionary = {
    "Wall/Title": "show_title",
    "Wall/Terminal2GateA": "show_t_2_g_a",
    "Wall/Terminal2GateB": "show_t_2_g_b",
    "Wall/Terminal2GateC": "show_t_2_g_c",
    "Wall/Terminal2GateD": "show_t_2_g_d",
    "Wall/Terminal2GateE": "show_t_2_g_e",
    "Wall/Terminal2GateF": "show_t_2_g_f",
    "Wall/Terminal2GateG": "show_t_2_g_g",
}

func _ready() -> void:
    # Set the visibility of the nodes once when the scene loads.
    for path in wall_parts:
        var node = get_node(path)
        if node:
            var should_show = get(wall_parts[path])
            if should_show:
                node.visible = should_show
