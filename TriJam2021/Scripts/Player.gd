extends KinematicBody2D


export var speed = 400
export(PackedScene) var projectile


func _physics_process(delta):
	var axis = _get_input_axis()
	move_and_slide(speed * axis)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		spawn_bullet()
	var mouseclick = event as InputEventMouseButton
	if mouseclick and mouseclick.pressed:
		spawn_bullet()


func spawn_bullet():
	var bullet = projectile.instance()
	bullet.global_position = global_position
	# rotate to mouse
	var mouse = get_global_mouse_position()
	var ang = global_position.angle_to_point(mouse)
	bullet.rotation = ang + PI
	$Bullets.add_child(bullet)


func _get_input_axis():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
