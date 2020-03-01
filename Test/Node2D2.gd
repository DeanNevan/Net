extends "res://Test/Node2D.gd"


var a = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	a = 2
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	yield(get_tree().create_timer(2), "timeout")
	print("eeeee")

func work():
	print("2")
