extends StaticBody2D

var col_layer
export var damage_amt = 1

var health = 3

func _ready():
	$AnimationPlayer.play("Fall")
	pass # Replace with function body.

func damage(amt):
	health -= amt
	if health <= 0:
		queue_free()


func _on_Area2D_body_entered(body):
	if body.has_method("damage"):
		print("damaging")
		body.damage(damage_amt)
	pass # Replace with function body.
