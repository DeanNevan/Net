extends Node2D

signal _all_done

signal nodes_work
signal keys_work

enum {
	KEYS_WORK
	NODES_WORK
}

var map_size = Vector2(30, 30)

var nodes_count = 0
var keys_count = 0

var _update_ok_children_count := 0
var is_update_done := false

var _done_children_count := 0
var who_work = NODES_WORK

var wait_time = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	connect("_all_done", self, "_on_all_done")
	
	if get_child_count() > 0:
		for i in get_child_count():
			if get_child(i).has_user_signal("update_ok"):
				get_child(i).connect("update_ok", self, "_on_child_update_ok")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_update_done:
		return
	match who_work:
		NODES_WORK:
			if _done_children_count == nodes_count:
				_done_children_count = 0
				emit_signal("_all_done")
		KEYS_WORK:
			if _done_children_count == keys_count:
				_done_children_count = 0
				emit_signal("_all_done")
	pass

func _on_all_done():
	yield(get_tree().create_timer(wait_time), "timeout")
	match who_work:
		NODES_WORK:
			_to_next_stage(KEYS_WORK)
		KEYS_WORK:
			_to_next_stage(NODES_WORK)

func _to_next_stage(stage):
	who_work = stage
	match who_work:
		NODES_WORK:
			emit_signal("nodes_work")
		KEYS_WORK:
			emit_signal("keys_work")
	pass

func _on_child_update_ok():
	_update_ok_children_count += 1
	

func _on_children_done():
	_done_children_count += 1
	pass
