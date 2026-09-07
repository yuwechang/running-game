extends CanvasLayer

@onready var replay_button := $Control/ReplayButton
@onready var score_label := $Control/ScoreLabel
@onready var settings_panel := $Control/PanelContainer

var total_score : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.replay.connect(
		func():
			replay_button.visible = true
	)
	SignalBus.add_score.connect(
		func(score : int):
			total_score += score
			score_label.text = "分數：%d" % total_score
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_replay_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_settings_button_pressed() -> void:
	settings_panel.visible = true
