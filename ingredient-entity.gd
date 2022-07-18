extends Area2D

var isPlayerHolding = false
var isPlayerThrowing = false
var isClickOnRight = true
var global_ingr_name = null
var speed = 1000
var screensize
var slope
var slope_vector
var y_intercept
var b_triangle
var c_triangle

func _ready():
	screensize = get_viewport_rect().size
	pass
	
#for initializing the ingredient tyoe
func initIngrName(ingr_name):
	global_ingr_name = ingr_name
	print(ingr_name)

#for getting the ingredient type
func getIngrName():
	return global_ingr_name

#when caldo picked the ingredient 
func _on_ingredientdrop_area_entered(area):
	if area.get_name() == "caldo-area" && !isPlayerThrowing:
		isPlayerHolding = true

func _process(delta):
	#for smart holding and throwing
	if isPlayerHolding && !isPlayerThrowing:
		set_position(get_node("/root/Node2D/Caldo-player").get_position()+Vector2(50,0))
	elif !isPlayerHolding && isPlayerThrowing:
		if isClickOnRight:
			set_position(position + Vector2(1,-1) * slope_vector * speed * delta)
		else:
			set_position(position + Vector2(-1,1) * slope_vector * speed * delta)
		
	#destroy when outside the screen
	if position.x > screensize.x || position.x < 0 || position.y < 0 || position.y > screensize.y:
		queue_free()
			
#for left clicking
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && isPlayerHolding:
			if event.pressed:
				isPlayerHolding = false
				isPlayerThrowing = true
				isClickOnRight = event.position.x > position.x
				
				#may math shit for aiming shit AHHAHAHHAHA
				slope = (position.y - event.position.y)/(event.position.x - position.x)
				slope_vector = Vector2(1, slope).normalized()
				print(slope_vector)
