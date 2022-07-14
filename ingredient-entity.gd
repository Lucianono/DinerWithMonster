extends Area2D

var isPlayerHolding = false
var isPlayerThrowing = false
var global_ingr_name = null
var screensize

var slope_vector

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
		set_position(position + slope_vector * delta)
		
	if position.x > screensize.x || position.y > screensize.y:
		queue_free()
			
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && isPlayerHolding:
			if event.pressed:
				print("ingr freed ", event.position)
				isPlayerHolding = false
				isPlayerThrowing = true
				
				var slope = (event.position.y - position.y)/(event.position.x - position.x)
				var yintercept = position.y - (slope * position.x)
				slope_vector = Vector2(200,(slope * event.position.x)+yintercept)
				print(slope,  " and " ,yintercept)
			
		
