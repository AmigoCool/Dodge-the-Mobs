extends CanvasLayer

signal start_game


func show_message(text):
	get_node("Message").text = text
	get_node("Message").show()
	get_node("MessageTimer").start()

func show_game_over():
	show_message("Game Over")
	yield(get_node("MessageTimer"), "timeout")
	get_node("Message").text = "Dodge the\nMobs!"
	get_node("Message").show()
	yield(get_tree().create_timer(1), "timeout")
	get_node("Button").show()

func update_score(score):
	get_node("Score").text = str(score)

func _on_Button_pressed():
	get_node("Button").hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	get_node("Message").hide()

