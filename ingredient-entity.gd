extends Area2D

var isPlayerHolding = false
var isPlayerThrowing = false
var global_ingr_name = null
var screensize
var left_click_event

var slope

func _ready():
	screensize = get_viewport_rect().size
	print(get_node("/root/Node2D/Caldo-player").get_position())
	pass
	
	
func initIngrName(ingr_name):
	global_ingr_name = ingr_name
	print(ingr_name)
	
func getIngrName():
	return global_ingr_name


func _on_ingredientdrop_area_entered(area):
	if area.get_name() == "caldo-area" && !isPlayerThrowing:
		isPlayerHolding = true

func _process(delta):
	if isPlayerHolding && !isPlayerThrowing:
		set_position(get_node("/root/Node2D/Caldo-player").get_position()+Vector2(70,0))
	elif !isPlayerHolding && isPlayerThrowing:
		if left_click_event.position.x > position.x:
			set_position(position + Vector2(1,-slope)* 500 * delta)
		else:
			set_position(position + Vector2(-1,-slope)* 500 * delta)
		
		
	if position.x > screensize.x || position.y > screensize.y:
		queue_free()
			
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && isPlayerHolding:
			if event.pressed:
				print("ingr freed ", event.position, position)
				isPlayerHolding = false
				isPlayerThrowing = true
				left_click_event = event
				
				slope = (position.y - event.position.y)/(event.position.x - position.x)
				print(slope)
			
		
