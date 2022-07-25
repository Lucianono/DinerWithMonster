extends KinematicBody2D

var speed = 1000
var slope_vector

var isClickOnRight = true

func _ready():
	set_physics_process(true)
	pass
	
func _physics_process(delta):
	isClickOnRight = get_node("/root/Node2D/Caldo-player").get_position().x > position.x
	
	slope_vector = GlobalVar.slope_calculate(position,get_node("/root/Node2D/Caldo-player").get_position())
	
	
	#for smart holding and throwing
	if isClickOnRight:
		move_and_slide(Vector2(1,-1) * slope_vector * speed * delta)
	else:
		move_and_slide(Vector2(-1,1) * slope_vector * speed * delta)
		
