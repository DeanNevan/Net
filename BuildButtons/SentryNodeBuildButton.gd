extends "res://Scripts/BasicBuildButton.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "哨兵节点"
	introduction = "-建造值：12" + "\n" + "-最大秩序值：6" + "\n"
	introduction += "-接收并消耗【1能量】：当【指定方向3格】内存在熵节点，向其他方向各发送【1能量】"
	introduction += "\n" + "\n" + "\n" + "——“哨兵凝视深渊”"
	color = Color(0.21, 0.61, 1, 1)
	NodeScene = preload("res://Nodes/OrderNode/SentryNode/SentryNode.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
