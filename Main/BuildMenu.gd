extends HBoxContainer

signal cancel_select
signal build_Node(node)

var build_target
var MainScene

# Called when the node enters the scene tree for the first time.
func _ready():
	MainScene = get_node("/root/Main")
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("selected", self, "_on_BuildButton_selected")
	$BuildList.connect("cancel_select", self, "_on_cancel_select")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if build_target != null and MainScene.is_double_selected:
		if MainScene.double_select_Node_or_Key.type == Global.NODE_TYPE.EMP_NODE:
			if MainScene.double_select_Node_or_Key.entropy_value == 0:
				$VBoxContainer/BuildButton.visible = true

func _on_BuildButton_selected(target):
	build_target = target
	emit_signal("cancel_select")
	pass

func _on_cancel_select():
	build_target = null

func _on_BuildButton_pressed():
	emit_signal("build_Node", build_target.NodeScene)
	pass # Replace with function body.
