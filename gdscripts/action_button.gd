extends Button

@export var action : StringName


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(
		func():
			var event := InputEventAction.new()
			event.action = action
			event.pressed = true
			Input.parse_input_event(event)
	)
	button_up.connect(
		func():
			var event := InputEventAction.new()
			event.action = action
			event.pressed = false
			Input.parse_input_event(event)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
