extends Area2D

var isPlayerHolding = false
var isPlayerThrowing = false
var global_ingr_name = null
var screensize
var isClickOnRight = true

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
		set_position(get_node("/root/Node2D/Caldo-player").get_position()+Vector2(50,0))
	elif !isPlayerHolding && isPlayerThrowing:
		if isClickOnRight:
			set_position(position + Vector2(1,-slope)* 700 * delta)
		else:
			set_position(position + Vector2(-1,slope)* 700 * delta)
		
		
	if position.x > screensize.x || position.x < 0 || position.y < 0 || position.y > screensize.y:
		queue_free()
			
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && isPlayerHolding:
			if event.pressed:
				isPlayerHolding = false
				isPlayerThrowing = true
				isClickOnRight = event.position.x > position.x
				
				slope = (position.y - event.position.y)/(event.position.x - position.x)
			
		
