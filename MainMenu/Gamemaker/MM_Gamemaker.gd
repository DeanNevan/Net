extends "res://MainMenu/MainMenuNode.gd"

signal back

onready var TweenLabel = Tween.new()

var info_size = Vector2()

onready var TweenGamemaker = Tween.new()
func _init():
	is_choice_node = true
	scene = preload("res://CustomStartMenu/CustomStartMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(TweenGamemaker)
	info_size = $Info.rect_size
	choice_node_color = $Sprite.modulate
	$Sprite.modulate = choice_node_color
	$Light2D.color = choice_node_color
	add_child(TweenLabel)
	cancel_select()
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("key_esc"):
		emit_signal("back")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start():
	get_parent().is_working = false
	#TweenGamemaker.interpolate_property(get_parent().get_node("WorldEnvironment").environment, "adjustment_brightness", get_parent().get_node("WorldEnvironment").environment.adjustment_brightness, 0.01, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	#TweenGamemaker.start()
	#yield(TweenGamemaker, "tween_completed")
	var info = load("res://MainMenu/Gamemaker/GamemakeInformation.tscn").instance()
	get_parent().get_node("CanvasLayer").add_child(info)
	#info.display()
	yield(self, "back")
	
	info.disappear()
	yield(info, "disappeared")
	
	info.queue_free()
	#TweenGamemaker.interpolate_property(get_parent().get_node("WorldEnvironment").environment, "adjustment_brightness", get_parent().get_node("WorldEnvironment").environment.adjustment_brightness, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	#TweenGamemaker.start()
	get_parent().is_working = true
	pass

func select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, info_size, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
	pass

func cancel_select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, Vector2(info_size.x, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
