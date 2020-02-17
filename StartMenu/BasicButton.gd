extends TextureButton


var Tween1 = Tween.new()
var Tween2 = Tween.new()
var Tween3 = Tween.new()

var Main = preload("res://Main/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	add_child(Tween2)
	add_child(Tween3)
	
	$Label.self_modulate = Color.black
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BasicButton_mouse_entered():
	Tween1.interpolate_property(self, "self_modulate", self_modulate, Color.black, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	Tween2.interpolate_property($Label, "self_modulate", $Label.self_modulate, Color.white, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween2.start()
	pass # Replace with function body.


func _on_BasicButton_mouse_exited():
	Tween1.interpolate_property(self, "self_modulate", self_modulate, Color.white, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	Tween2.interpolate_property($Label, "self_modulate", $Label.self_modulate, Color.black, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween2.start()
	pass # Replace with function body.


func _on_BasicButton_button_down():
	self.rect_scale = Vector2(0.8, 0.8)
	self.rect_position += Vector2(18, 18)
	
	pass # Replace with function body.


func _on_BasicButton_button_up():
	self.rect_scale = Vector2(1, 1)
	self.rect_position -= Vector2(18, 18)
	pass # Replace with function body.


func _on_BasicButton_pressed():
	Tween3.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween3.start()
	yield(get_tree().create_timer(0.7), "timeout")
	print("start game")
	get_tree().change_scene_to(Main)
	pass # Replace with function body.
