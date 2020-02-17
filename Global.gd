extends Node

#ENT——熵值
#ORD——秩序值
#SENT——超熵值
#EGY——能量值
enum VALUE_TYPE{
	EGY
	ENT
	ORD
}

enum NODE_TYPE{
	ENT_NODE#熵节点
	ORD_NODE#秩序节点
	EMP_NODE#非秩序节点
}

enum KEY_TYPE{
	KEY
}

var NODE_RADIUS = 49.5
var KEY_LENGTH = 60

var MAX_ENT = 10
var MAX_ORD = 10
var MAX_SENT = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_node_position_with_location(location : Vector2):
	var pos
	pos = Vector2((location.x - 1) * (2 * Global.NODE_RADIUS + Global.KEY_LENGTH), (location.y - 1) * (2 * Global.NODE_RADIUS + Global.KEY_LENGTH))
	return pos
	pass
