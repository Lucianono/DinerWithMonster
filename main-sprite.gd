extends KinematicBody2D

onready var raycast_right = get_node("RayCast2D") 

var isPlayerColliding = false
var kboard = Vector2(0,0)
export var speed = 200

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	
	kboard.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	kboard.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	kboard = kboard.normalized() * speed
	kboard = move_and_slide(kboard)
	
	print("h")
	
	
	
	
