extends Node2D

var max_leftout_enemies = 10

func on_update_health_bar():
	var s = StatsManager.get_enemy_count() - StatsManager.get_death_count()
	$HeathBar._on_health_updated(s, null)
	pass

func _on_sweet_spawned():
	on_update_health_bar()

func _on_update_score_text(score):
	on_update_health_bar()
	$HUDControls/ScoreLabel.set_text("crushed: %d" % [score])


func _on_game_over():
	$GameOverPopup.show()
	StatsManager.update_game_over()
	


func _ready():
	$GameOverPopup.hide()
	$HeathBar._on_max_health_updated(max_leftout_enemies)
	$HeathBar._on_health_updated(max_leftout_enemies, null)
	$HUDControls/ScoreLabel.set_text("crushed: %d" % [0])
	SignalManager.connect("sweet_spawned", self, "_on_sweet_spawned")	
	SignalManager.connect("score_updated", self, "_on_update_score_text")
	SignalManager.connect("game_over", self, "_on_game_over")


func _on_Button_pressed():
	Global.goto_scene("res://Scenes/Scene.tscn")
