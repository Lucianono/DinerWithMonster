extends KinematicBody2D


var slope
var slope_vector =0.1

var isClickOnRight = true

func _ready():
	pass
	
func _process(delta):
	isClickOnRight = get_node("/root/Node2D/Caldo-player").get_position().x > position.x
	
	slope = (position.y - get_node("/root/Node2D/Caldo-player").get_position().y)/(get_node("/root/Node2D/Caldo-player").get_position().x - position.x)
	slope_vector = Vector2(1, slope).normalized()
	print(slope_vector)
	
	
	#for smart holding and throwing
	if isClickOnRight:
		move_and_slide(Vector2(1,-1) * slope_vector * 10000 * delta)
	else:
		move_and_slide(Vector2(-1,1) * slope_vector * 10000 * delta)
		

#for left clicking
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT :
			if event.pressed:
				
				isClickOnRight = get_node("/root/Node2D/Caldo-player").get_position().x > position.x
				
				#may math shit for aiming shit AHHAHAHHAHA
				slope = (position.y - get_node("/root/Node2D/Caldo-player").get_position().y)/(get_node("/root/Node2D/Caldo-player").get_position().x - position.x)
				slope_vector = Vector2(1, slope).normalized()
				print(slope_vector)
