extends HBoxContainer

signal cancel_select
signal build_Node(node)

var build_target
var MainScene

# Called when the node enters the scene tree for the first time.
func _ready():
	MainScene = get_node("/root/Main")
	for i in get_tree().get_nodes_in_group("build_targets"):
		i.connect("selected", self, "_on_BuildTarget_selected")
		i.connect("cancel_select", self, "_on_BuildTarget_cancel_select")
	$BuildList.connect("cancel_select", self, "_on_cancel_select")
	MainScene.connect("built", self, "_on_built")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if build_target != null and MainScene.is_selected and is_instance_valid(MainScene.select_Node_or_Key):
		if MainScene.select_Node_or_Key.type == Global.NODE_TYPE.EMP_NODE:
			if MainScene.select_Node_or_Key.entropy_value == 0:
				#print("can_build")
				$VBoxContainer/BuildButton.visible = true
			else:
				$VBoxContainer/BuildButton.visible = false
		else:
			$VBoxContainer/BuildButton.visible = false
	else:
		$VBoxContainer/BuildButton.visible = false

func _on_BuildTarget_selected(target):
	build_target = target
	pass

func _on_cancel_select():
	#$VBoxContainer/BuildButton.visible = false
	for i in get_tree().get_nodes_in_group("build_targets"):
		i.pressed = false
	emit_signal("cancel_select")
	build_target = null

func _on_BuildTarget_cancel_select(target):
	#$VBoxContainer/BuildButton.visible = false
	#build_target = null
	pass

func _on_BuildButton_pressed():
	emit_signal("build_Node", build_target.NodeScene)
	$VBoxContainer/BuildButton.visible = false
	pass # Replace with function body.

func _on_built():
	#build_target = null
	pass
	#$VBoxContainer/BuildButton.visible = false
