extends Camera2D

@export var player : Node2D

var last_player_position_x : float


func _ready() -> void:
	last_player_position_x = player.global_position.x

func _process(delta: float) -> void:
	global_position.x += player.global_position.x - last_player_position_x
	last_player_position_x = player.global_position.x
