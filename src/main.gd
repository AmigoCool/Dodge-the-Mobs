extends Node

export (PackedScene) var Mob

var score

func _ready():
	randomize()

func _on_StartTimer_timeout(): #starttimer開始計時時
	get_node("MobTimer").start()
	get_node("ScoreTimer").start()

func _on_ScoreTimer_timeout(): #scoretimer開始計時時
	score += 1
	get_node("MainHUD").update_score(score)

func _on_MainHUD_start_game():  
	score = 0
	get_node("Player").start(get_node("StartPosition").position)
	get_node("StartTimer").start()
	get_node("MainHUD").update_score(score)
	get_node("MainHUD").show_message("Get Ready")
	get_node("BGM").play()

func _on_MobTimer_timeout(): #變出mob
	get_node("MobPath/MobSpawnLocation").offset = randi()
	var mob = Mob.instance()
	add_child(mob)
	var direction = get_node("MobPath/MobSpawnLocation").rotation + PI / 2
	mob.position = get_node("MobPath/MobSpawnLocation").position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
#func game_over(): #gameover時 
#	get_node("ScoreTimer").stop()
#	get_node("MobTimer").stop()
#	get_node("MainHUD").show_game_over()
#	get_tree().call_group("mobs", "queue_free")

func _on_Player_bomb(): #小改部分 使用炸彈時
	get_node("ColorRect/TextureRect").hide()
	get_tree().call_group("mobs", "queue_free")
	get_node("Bombsound").play()
	yield(get_tree().create_timer(1.0), "timeout")
	get_node("Bombsound").stop()


func _on_Player_hit(): #撞到時
	get_node("ScoreTimer").stop()
	get_node("MobTimer").stop()
	get_node("MainHUD").show_game_over()
	get_tree().call_group("mobs", "queue_free")
	get_node("BGM").stop()
	get_node("game_overBGM").play()
