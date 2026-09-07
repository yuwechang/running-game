extends Area2D

@export var score := 1


func _on_body_entered(body: Node2D) -> void:
	SignalBus.add_score.emit(score)
	queue_free()
