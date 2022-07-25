extends KinematicBody2D

var speed = 10000
var slope_vector


func _ready():
	set_physics_process(true)
	pass
	
func _physics_process(delta):
	var isPlayerOnRight = get_node("/root/Node2D/Caldo-player").get_position().x > position.x
	slope_vector = GlobalVar.slope_calculate(position,get_node("/root/Node2D/Caldo-player").get_position())
	
	
	#for smart following
	if isPlayerOnRight:
		move_and_slide(Vector2(1,-1) * slope_vector * speed * delta)
	else:
		move_and_slide(Vector2(-1,1) * slope_vector * speed * delta)
		
