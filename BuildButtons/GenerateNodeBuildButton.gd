extends "res://Scripts/BasicBuildButton.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "生产节点"
	introduction = "-建造值：8" + "\n" + "-最大秩序值：4" + "\n"
	introduction += "-当周围没有熵节点或熵大于0的空节点，每回合向【指定方向】发送【1能量】"
	introduction += "\n" + "\n" + "\n" + "——“向伟大的生产者致敬”"
	color = Color(0.19, 0.49, 0.76, 1)
	NodeScene = preload("res://Nodes/OrderNode/GenerateNode/GenerateNode.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
