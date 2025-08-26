extends Node3D

@onready var animation_player = $waving_lady/AnimationPlayer

# animation_player.play("Idle")

func _ready():
  var anim = animation_player.get_animation("Armature|mixamo_com|Layer0")
  if anim:
    anim.loop = true
  animation_player.play("Armature|mixamo_com|Layer0")
