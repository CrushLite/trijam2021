extends Node2D


export var speed = 800
export var damage_amt = 1
export var direction = Vector2(1, 0)


func _physics_process(delta):
	position += direction.rotated(rotation) * speed * delta


func _on_Area2D_body_entered(body):
	if body.has_method("damage"):
		body.damage(damage_amt)
	queue_free()
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	print("area entered", area.name)
	queue_free()
	pass # Replace with function body.
