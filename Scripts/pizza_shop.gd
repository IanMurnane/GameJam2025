extends Node3D


func _on_area_3d_body_exited(body: Node3D) -> void:
	# publish:
	EventBus.player_exited.emit()


func _on_area_3d_body_entered(body: Node3D) -> void:
	# publish:
	EventBus.player_entered.emit()
