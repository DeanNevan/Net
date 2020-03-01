extends TextureRect

#{0:{0:2,1:1,2:3,3:4}, 1:{}}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func clear():
	for i in $In.get_child_count():
		$In.get_child(i).visible = false
	for i in $Out.get_child_count():
		$Out.get_child(i).visible = false

func display(values : Dictionary):
	clear()
	if values.size() == 0:
		return
	if values.keys().has(0):
		for i in values[0]:
			if values[0][i] > 0:
				$In.get_child(i).visible = true
				$In.get_child(i).get_node("Label").text = str(values[0][i])
	if values.keys().has(1):
		for i in values[1]:
			if values[1][i] > 0:
				$Out.get_child(i).visible = true
				$Out.get_child(i).get_node("Label").text = str(values[1][i])
