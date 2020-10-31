extends Node2D

export var time = 2.0

func _ready():
	yield(get_tree().create_timer(time), "timeout")
	queue_free()
