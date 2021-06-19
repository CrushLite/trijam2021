extends KinematicBody2D


export var speed = 400


func _physics_process(delta):
	var axis = _get_input_axis()
	move_and_slide(speed * axis)


func _get_input_axis():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
