extends KinematicBody2D


export(NodePath) var player_path
export(NodePath) var move_targets_path
export(NodePath) var rock_spawn_area_path
export(NodePath) var rocks_path
export(NodePath) var health_bar_path
export(PackedScene) var rock
export(int, 1, 5, 1) var rocks_to_spawn = 1

onready var rock_wave = preload("res://Scenes/SlamWave.tscn")

onready var player = get_node(player_path) as KinematicBody2D
onready var move_targets = get_node(move_targets_path) as Node
onready var rock_spawn_area = get_node(rock_spawn_area_path) as Area2D
onready var rocks = get_node(rocks_path) as YSort
onready var health_bar = get_node(health_bar_path) as TextureProgress


enum States { IDLE, SLASH, DASH }
var state = States.IDLE

onready var curr_pos : Position2D = move_targets.get_child(0)


var health = 10

func damage(amt):
	health -= amt
	health_bar.value = health
	if health <= 0:
		queue_free()


func _ready():
	pass
	
	

func spawn_rock_wave():
	var rrock_wave = rock_wave.instance()
	rrock_wave.global_position = global_position
	# rotate to downwards
	rrock_wave.speed = 200
	rrock_wave.rotation = PI/2
	$Bullets.add_child(rrock_wave)


func _on_MoveTimer_timeout():
#	clear_rocks()
	randomize()
	if randi() % 2 == 0: 
		$AnimatedSprite.play("Rock Throw")
#		rock_throw()
	else:
		move_to_position_closest_to_player()
		spawn_rock_wave()
		$MoveTimer.start()
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
	


func clear_rocks():
	for r in rocks.get_children():
		r.queue_free()


# Need a rock throw attack
# rocks move to random positions and create hazards
func rock_throw():
	# spawns a thing at random positions
	var shape = (rock_spawn_area.get_child(0).shape as RectangleShape2D)
	var area_pos = rock_spawn_area.position - shape.extents
	var area_size = shape.extents * 2
	var obj_size = Vector2(32, 32)
	
	var rect: Rect2 = Rect2(area_pos, area_size)
	var points = []
	
	randomize()
	while len(points) < rocks_to_spawn:
		var point = area_pos + Vector2(randi() % int(area_size.x), randi() % int(area_size.y))
		points.append(point)
	
	for point in points:
#		var point = get_placement_pos(area_pos, area_size, obj_size)
#		print(area_pos, area_size, point)
		var _rock : StaticBody2D = rock.instance()
		_rock.position = point
		rocks.add_child(_rock)
	


func get_placement_pos(area_pos: Vector2, area_size: Vector2, obj_size: Vector2, including_edges: bool = false) -> Vector2:
	assert(obj_size.x < area_size.x)
	assert(obj_size.y < area_size.y)

	var x := int(area_pos.x)
	var y := int(area_pos.y)
	var w := int(area_size.x)
	var h := int(area_size.y)

	var max_x = area_size.x - obj_size.x
	var max_y = area_size.y - obj_size.y

	if including_edges:
		w += 1
		h += 1
	else:
		x += 1
		y += 1
		w -= 1
		h -= 1
		max_x -= 1
		max_y -= 1

	randomize()
	var random_x = x + (randi() % w)
	var random_y = y + (randi() % h)
	var random_pos := Vector2(random_x, random_y)

	random_pos.x = min(random_pos.x, max_x)
	random_pos.y = min(random_pos.y, max_y)
	return random_pos


#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		var area_pos := Vector2(0, 0)
#		var area_size := Vector2(8, 8)
#		var obj_size := Vector2(2, 2)
#		var placement_pos := get_placement_pos(area_pos, area_size, obj_size, true)
#		print("placement_pos: ", placement_pos)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Rock Throw":
		rock_throw()
		$AnimatedSprite.play("idle")
		$MoveTimer.start()
	pass # Replace with function body.
