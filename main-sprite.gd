extends Area2D

export var speed = 200
var i = 1

func _ready():
	set_process(true)
	
func _process(delta):
	var kboard = Vector2(0,0)
	kboard.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	kboard.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))	
	set_position(position + (kboard * speed * delta))
