extends CharacterBody2D

@export var run_speed := 480.0
@export var jump_height := 96.0
@export var time_to_peak := 0.2

@onready var anim_tree := $AnimationTree
@onready var ray_cast := $RayCast2D
@onready var collision_shape := $CollisionShape2D
@onready var jump_audio := $"jump"

var gravity : float
var jump_velocity : float
var playback : AnimationNodeStateMachinePlayback
var jump_count := 0
var is_on_ground : bool
var is_alive := true
var is_slide_button_pressed : bool
var is_jump_button_pressed : bool


func _ready() -> void:
	velocity.x = run_speed
	velocity.y = 0
	gravity = (2 * jump_height) / (time_to_peak * time_to_peak)
	jump_velocity = -sqrt(2 * gravity * jump_height)
	playback = $AnimationTree.get("parameters/playback")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("slide"): is_slide_button_pressed = true
	if event.is_action_released("slide"): is_slide_button_pressed = false
	if event.is_action_pressed("jump"): is_jump_button_pressed = true

func _physics_process(delta: float) -> void:
	if ray_cast.is_colliding() or is_on_floor():
		is_on_ground = true
		if is_alive:
			velocity.x = run_speed

		if is_slide_button_pressed:
			anim_tree.set("parameters/conditions/is_slide", true)
			anim_tree.set("parameters/conditions/is_run", false)
		else:
			anim_tree.set("parameters/conditions/is_slide", false)
			anim_tree.set("parameters/conditions/is_run", true)

		if is_jump_button_pressed:
			velocity.y = jump_velocity
			playback.travel("jump_up")
			jump_count = 1
			jump_audio.play()
	else:
		is_on_ground = false
		if jump_count == 1 and is_jump_button_pressed and velocity.y < 0:
			velocity.y = jump_velocity
			playback.travel("double_jump")
			jump_count = 2
			jump_audio.play()
		else:
			velocity.y += gravity * delta

	is_jump_button_pressed = false
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider() as Node
		if collider.is_in_group("Obstacle"):
			collision_shape.set_deferred("disabled", true)
			var force = Vector2(-1, -1)
			velocity = force.normalized() * run_speed
			is_alive = false
			break
		elif not is_on_ground:
			var normal = collision.get_normal()
			if abs(normal.x) > 0.5:
				velocity = normal * run_speed
				break


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	get_tree().paused = true
	SignalBus.replay.emit()
