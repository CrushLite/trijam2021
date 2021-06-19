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


# Need a rock throw attack
# rocks move to random positions and create hazards
func rock_throw():
	# spawns a thing at random positions
	pass


func _on_MoveTimer_timeout():
	move_to_position_closest_to_player()
#	move_to_random_position()


func move_to_position_closest_to_player():
	# get position closest to player
	var closest = null
	var dist = null
	var player_pos = player.global_position
	for p in move_targets.get_children():
		var d = p.position.distance_to(player_pos)
		if closest == null or d < dist:
			closest = p
			dist = d
	# move to that position
	_move_to(closest)
	pass


# Randomly change position
func move_to_random_position():
	# move to a random position
	randomize()
	var pos : Position2D = curr_pos
	while pos == curr_pos:
		var child_index = randi() % move_targets.get_child_count()
		pos = move_targets.get_child(child_index)
	_move_to(pos)

func _move_to(pos : Position2D):
	global_position = pos.global_position
	curr_pos = pos
	
