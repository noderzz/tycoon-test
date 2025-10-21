class_name TravelerController
extends PathFollow2D

@export var move_speed: float = 0.25 # fraction of the loop per second
var target_ratio: float

func _ready() -> void:
	rotates = false
	loop = true
	target_ratio = progress_ratio

func _unhandled_input(event: InputEvent) -> void:
	# Step around the loop in 1/8th increments with arrow keys
	if event.is_action_pressed("ui_right"):
		target_ratio = fposmod(target_ratio + 0.125, 1.0)
	elif event.is_action_pressed("ui_left"):
		target_ratio = fposmod(target_ratio - 0.125 + 1.0, 1.0)

func _process(delta: float) -> void:
	# Move toward target_ratio taking shortest wrap-around path
	var diff: float = fposmod(target_ratio - progress_ratio + 1.0, 1.0)
	if diff > 0.5:
		diff -= 1.0
	# 'max_step' uses delta to determine how much of a distance we can move in a frame.
	var max_step: float = move_speed * delta
	# 'step' is used to determine if we're at the destination or not. If diff is bigger than max_step then we just go max_step distance. If it's smaller then we use that value and we've arrived.
	var step: float = clampf(diff, -max_step, max_step)
	progress_ratio = fposmod(progress_ratio + step + 1.0, 1.0)
