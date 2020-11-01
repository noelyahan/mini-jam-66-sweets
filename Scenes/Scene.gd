extends Node2D

const Enemy = preload("res://EnemyKK.tscn")
var screensize
export var enemy_count = 10

func _on_score_updated(x):
	var c = StatsManager.get_enemy_count() - StatsManager.get_death_count()
	var t = rand_range(1, 3)
	var e = rand_range(enemy_count, enemy_count * t)
	if c <= 3 and not StatsManager.game_over:
		spawn_enemies(enemy_count, t)
	

func _ready():
	StatsManager.init()
	screensize = get_viewport().get_visible_rect().size
	AudioManager.play("res://assets/sounds/bg_music_chill.ogg")
	SignalManager.connect("score_updated", self, "_on_score_updated")	
	spawn_enemies(enemy_count, 3)
	
func spawn_enemies(n, time):
	StatsManager.update_enemy_count(enemy_count)	
	for i in range (n):
		yield(get_tree().create_timer(time), "timeout")
		randomize()
		var x = rand_range(50, screensize.x - 50)
		var y = rand_range(120, 140)
		var e = Enemy.instance()
		e.collision_mask = 26
		e.position = Vector2(x, 0)
		$Enemies.add_child(e)
		SignalManager.emit_signal("sweet_spawned", Vector2(e.position.x, y))
		
	
func _process(delta):
	pass
