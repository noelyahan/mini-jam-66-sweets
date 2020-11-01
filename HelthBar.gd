extends Control

export (Color) var healthy_color = Color.green
export (Color) var danger_mid = Color.orange
export (Color) var danger_color = Color.red

onready var health_bar := $HealthBar

func _on_health_updated(health, amount):
	health_bar.value = health
	_assign_color(health_bar, health_bar.max_value, health_bar.value)

func _assign_color(bar, health_max, health):
	if health == health_max:
		bar.tint_progress = healthy_color
		return
	var p = (health/health_max) * 100
	if p <= 50 && p >= 0:
		bar.tint_progress = danger_color
	if p <= 75 && p > 50:
		bar.tint_progress = danger_mid
	if p <= 100 && p >= 75:
		bar.tint_progress = healthy_color
	
func _on_max_health_updated(max_value):
	health_bar.max_value = max_value
