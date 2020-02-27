extends RichTextLabel


var target_info


# Called when the node enters the scene tree for the first time.
func _ready():
	bbcode_text = "\n" + "[center]" + "初始化信息" + "[/center]" + "\n" + "\n" + "初始化信息" + "\n" + "\n"
	for i in get_tree().get_nodes_in_group("build_targets"):
		i.connect("selected", self, "_on_BuildTarget_selected")
		i.connect("cancel_select", self, "_on_BuildTarget_cancel_select")
	get_parent().get_parent().get_parent().connect("cancel_select", self, "_on_cancel_select")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_BuildTarget_selected(target):
	visible = true
	target_info = target
	modulate = target.color
	bbcode_enabled = false
	bbcode_text = "\n" + "[center]" + target.name_CN + "[/center]" + "\n" + "\n" + target.introduction + "\n" + "\n"
	bbcode_enabled = true

func _on_cancel_select():
	target_info = null
	bbcode_enabled = false
	bbcode_text = "\n" + "[center]" + "初始化信息" + "[/center]" + "\n" + "\n" + "初始化信息" + "\n" + "\n"
	bbcode_enabled = true

func _on_BuildTarget_cancel_select(target):
	if target == target_info:
		bbcode_enabled = false
		bbcode_text = "\n" + "[center]" + "初始化信息" + "[/center]" + "\n" + "\n" + "初始化信息" + "\n" + "\n"
		bbcode_enabled = true
	pass
