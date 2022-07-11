extends KinematicBody2D

var isPlayerColliding = false
var kboard
export var speed = 200

func _ready():
	set_process(true)
	
func _process(delta):
	kboard = Vector2(0,0)
	kboard.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	kboard.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	move_and_slide(position + (kboard * speed * delta))
	
	
	
	
