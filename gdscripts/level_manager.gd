extends Node

@export var road_scenes : Array[PackedScene]


func _ready() -> void:
	SignalBus.spawn_next_road.connect(on_spawn_next_road)


func on_spawn_next_road(next_pos : Vector2):
	if road_scenes.is_empty(): return
	var new_road : Node2D = road_scenes.pick_random().instantiate()
	new_road.global_position = next_pos
	add_child(new_road)
