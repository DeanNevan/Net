extends Node2D

signal a

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("a", self, "work")
	emit_signal("a")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func work():
	print("1")