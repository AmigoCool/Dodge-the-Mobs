extends Area2D

var speed = 400
var screen_size 
var bomb = 1

signal hit
signal bomb

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var pos = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		pos.x += 1

	if Input.is_action_pressed("ui_left"):
		pos.x -= 1

	if Input.is_action_pressed("ui_down"):
		pos.y += 1
		
	if Input.is_action_pressed("ui_up"):
		pos.y -= 1
	if pos.length() > 0:
		pos = pos.normalized() * speed * delta
		get_node("AnimatedSprite").play()
	else:
		get_node("AnimatedSprite").stop()
	position += pos
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if Input.is_action_pressed("space"): #空白鍵按下時
		if bomb >=1:
			bomb = bomb - 1
			emit_signal("bomb")
		else:
			pass

	if pos.x != 0:
		get_node("AnimatedSprite").animation ="walk"
		get_node("AnimatedSprite").flip_v = false
		get_node("AnimatedSprite").flip_h = pos.x < 0

	elif pos.y != 0:
		get_node("AnimatedSprite").animation ="up"
		get_node("AnimatedSprite").flip_v = pos.y > 0 

func start(pos):
	position = pos
	show()
	get_node("CollisionShape2D").disabled = false


func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	get_node("CollisionShape2D").set_deferred("disiable",true)
