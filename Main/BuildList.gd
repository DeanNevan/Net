extends MarginContainer

signal cancel_select

var on_mouse = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("list_choices"):
		i.connect("selected", self, "_on_list_choices_selected")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_mouse:
		if Input.is_action_just_pressed("right_mouse_button"):
			emit_signal("cancel_select")


func _on_BuildList_mouse_entered():
	on_mouse = true
	pass # Replace with function body.


func _on_BuildList_mouse_exited():
	on_mouse = false
	pass # Replace with function body.

func _on_list_choices_selected(list_number):
	var _display_list
	match list_number:
		1:
			get_node("BuildList1").visible = true
			get_node("BuildList2").visible = false
			get_node("BuildList2").visible = false
		2:
			get_node("BuildList1").visible = false
			get_node("BuildList2").visible = true
			get_node("BuildList2").visible = false
		3:
			get_node("BuildList1").visible = false
			get_node("BuildList2").visible = true
			get_node("BuildList2").visible = false
	
