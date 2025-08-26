extends Node3D

@onready var indianman_player = $Sketchfab_Scene4/AnimationPlayer
@onready var coolman_player = $Sketchfab_Scene2/AnimationPlayer

# animation_player.play("Idle")

func _ready():
  var anim = indianman_player.get_animation("mixamo_com")
  var cool_anim = coolman_player.get_animation("salute")
  if anim:
    anim.loop = true
  if cool_anim:
    cool_anim.loop = true
  indianman_player.play("mixamo_com")
  coolman_player.play("salute")


#func _on_area_3d_body_entered(body: Node3D) -> void:
  ## publish:
  #EventBus.player_entered.emit()
  #pass # Replace with function body.
#
#
#func _on_area_3d_body_exited(body: Node3D) -> void:
  ## publish:
  #EventBus.player_exited.emit()
  #pass # Replace with function body.
