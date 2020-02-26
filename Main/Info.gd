extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	bbcode_text = "\n" + "[center]" + "初始化信息" + "[/center]" + "\n" + "\n" + "初始化信息" + "\n" + "\n"
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("selected", self, "_on_BuildButton_selected")
	get_parent().get_parent().get_parent().connect("cancel_select", self, "_on_cancel_select")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_BuildButton_selected(target):
	visible = true
	modulate = target.color
	bbcode_text = "\n" + "[center]" + target.name_CN + "[/center]" + "\n" + "\n" + target.introduction + "\n" + "\n"
	pass

func _on_cancel_select():
	bbcode_text = ""
