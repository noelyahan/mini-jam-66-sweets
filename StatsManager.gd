extends Node

var score = 0
var total_enemy_count = 0
var death_count = 0
var game_over = false
var liquid_state = 0


func init():
	score = 0
	total_enemy_count = 0
	death_count = 0
	game_over = false
	liquid_state = 0
	randomize()
	liquid_state = randi() % 3

func _ready():
	init()

func get_liquid_state():
	return liquid_state

func update_game_over():
	game_over = true

func get_enemy_count():
	return total_enemy_count
	
func get_death_count():
	return death_count
	
func update_death_count(c):
	if game_over:
		return
	self.death_count += c
	
func update_enemy_count(c):
	if game_over:
		return
	self.total_enemy_count += c

func get_score():
	return score

func update_score(score):
	if game_over:
		return
	self.score = score
	SignalManager.emit_signal("score_updated", self.score)
