extends "res://MainMenu/MainMenuNode.gd"

signal exit_game

onready var TweenLabel = Tween.new()

var info_size = Vector2()

onready var TweenExitGame = Tween.new()

func _init():
	is_choice_node = true
	scene = preload("res://CustomStartMenu/CustomStartMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(TweenExitGame)
	info_size = $Info.rect_size
	choice_node_color = $Sprite.modulate
	$Sprite.modulate = choice_node_color
	$Light2D.color = choice_node_color
	add_child(TweenLabel)
	cancel_select()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start():
	get_parent().is_working = false
	TweenExitGame.interpolate_property(get_parent().get_node("WorldEnvironment").environment, "adjustment_brightness", get_parent().get_node("WorldEnvironment").environment.adjustment_brightness, 0.01, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenExitGame.start()
	yield(TweenExitGame, "tween_completed")
	get_tree().quit()
	pass

func select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, info_size, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
	pass

func cancel_select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, Vector2(info_size.x, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
