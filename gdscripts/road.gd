extends Node2D


@onready var end := $VisibleOnScreenNotifier2D

var is_next_spawned := false


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if not is_next_spawned:
		SignalBus.spawn_next_road.emit(end.global_position)
		is_next_spawned = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if end.get_global_transform_with_canvas().origin.x < 0:
		queue_free()
