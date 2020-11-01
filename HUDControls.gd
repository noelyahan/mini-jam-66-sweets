extends Control


func _on_update_score_text(score):
	$ScoreLabel.set_text("crushed: %d" % [score])


func _ready():
	$ScoreLabel.set_text("crushed: %d" % [0])
	SignalManager.connect("score_updated", self, "_on_update_score_text")
