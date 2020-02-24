extends "res://Test/Node2D.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var a = [1, 4]
	a.erase(1)
	print(a)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	yield(get_tree().create_timer(2), "timeout")
	print("eeeee")

func work():
	print("2")
