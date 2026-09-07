extends PanelContainer

@onready var master_bus := AudioServer.get_bus_index("Master")
@onready var music_bus := AudioServer.get_bus_index("Music")
@onready var afx_bus := AudioServer.get_bus_index("AFX")

@onready var music_slider := $VBoxContainer/Center/GridContainer/MusicSlider
@onready var afx_slider := $VBoxContainer/Center/GridContainer/AFXSlider
@onready var mute_button := $VBoxContainer/Center/GridContainer/MuteCheckButton

var config := ConfigFile.new()
var is_replaying := false

func load_data() -> void:
	var err = config.load("user://save_data.cfg")
	if err == OK:
		music_slider.value = config.get_value("audio", "music", 1)
		afx_slider.value = config.get_value("audio", "afx", 1)
		mute_button.button_pressed = config.get_value("audio", "mute", false)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		load_data()
		SignalBus.replay.connect(
			func(): is_replaying = true
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		get_parent().move_child(self, get_parent().get_child_count() - 1)
		get_tree().paused = true
	else:
		get_tree().paused = false if not is_replaying else true


func _on_close_button_pressed() -> void:
	load_data()
	visible = false


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))


func _on_afx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(afx_bus, linear_to_db(value))


func _on_mute_check_button_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(master_bus, toggled_on)


func _on_save_button_pressed() -> void:
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "afx", afx_slider.value)
	config.set_value("audio", "mute", mute_button.button_pressed)
	config.save("user://save_data.cfg")
	visible = false
