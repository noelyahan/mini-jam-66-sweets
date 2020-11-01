extends Node

var score = 0
var enemy_count = 0

func get_enemy_count():
	return enemy_count
	
func update_enemy_count(c):
	self.enemy_count = c
	SignalManager.emit_signal("enemy_count_updated", enemy_count)

func get_score():
	return score

func update_score(score):
	self.score = score
	SignalManager.emit_signal("score_updated", self.score)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
