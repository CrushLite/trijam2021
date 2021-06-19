extends Node2D


export var speed = 800
export var direction = Vector2(1, 0)


func _physics_process(delta):
	position += direction.rotated(rotation) * speed * delta


func _on_Area2D_body_entered(body):
	queue_free()
	pass # Replace with function body.
