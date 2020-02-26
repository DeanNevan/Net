extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_parent().connect("cancel_select", self, "_on_cancel_select")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_cancel_select():
	visible = false
