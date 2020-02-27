extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("build_targets"):
		#i.connect("selected", self, "_on_BuildTarget_selected")
		#i.connect("cancel_select", self, "_on_BuildTarget_cancel_select")
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_BuildTarget_cancel_select(target):
	#visible = false
	pass


func _on_BuildMenu_cancel_select():
	visible = false
	pass # Replace with function body.
