extends "res://Scripts/BasicBuildButton.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "生产节点"
	introduction = "这是一段introduction"
	color = Color(0.19, 0.49, 0.76, 1)
	NodeScene = preload("res://Nodes/OrderNode/GenerateNode/GenerateNode.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
