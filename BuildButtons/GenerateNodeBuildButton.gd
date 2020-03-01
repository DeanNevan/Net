extends "res://Scripts/BasicBuildButton.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	NodeScene = load("res://Nodes/OrderNode/GenerateNode/GenerateNode.tscn")
	update_info()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
