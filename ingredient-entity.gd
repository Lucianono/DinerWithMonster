extends Area2D

var isPlayerHolding = false
var global_ingr_name = null

func _ready():
	print(get_node("/root/Node2D/Caldo-player").get_position())
	pass
	
	
func initIngrName(ingr_name):
	global_ingr_name = ingr_name
	print(ingr_name)
	
func getIngrName():
	return global_ingr_name


func _on_ingredientdrop_area_entered(area):
	if area.get_name() == "caldo-area" :
		isPlayerHolding = true

func _process(_delta):
	if isPlayerHolding:
		set_position(get_node("/root/Node2D/Caldo-player").get_position()+Vector2(70,0))
	else :
		set_position(position + Vector2(10,0))
			
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && isPlayerHolding:
			if event.pressed:
				print("ingr freed ", event.position)
				isPlayerHolding = false
		
