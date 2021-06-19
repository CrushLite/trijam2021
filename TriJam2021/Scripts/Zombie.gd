extends KinematicBody2D


export(NodePath) var player_path
export(NodePath) var move_targets_path


onready var player = get_node(player_path)
onready var move_targets = get_node(move_targets_path)


enum States { IDLE, SLASH, DASH }
var state = States.IDLE

onready var curr_pos : Position2D = move_targets.get_child(0)


func _ready():
	pass
	
	
#
#
#func _process(delta):
#	match state:
#		States.IDLE:
#			idle()
#		States.SLASH:
#			slash()
#		States.DASH:
#			dash()
#
#
#func idle():
#	$AnimatedSprite.play("idle")
#	pass
#
#
#func dash():
#	pass
#
#
#func slash():
#	pass


func _on_MoveTimer_timeout():
	# move to a random position
	randomize()
	var pos : Position2D = curr_pos
	while pos == curr_pos:
		var child_index = randi() % move_targets.get_child_count()
		pos = move_targets.get_child(child_index)
	global_position = pos.global_position
	curr_pos = pos
	print("Move!")
	pass # Replace with function body.
