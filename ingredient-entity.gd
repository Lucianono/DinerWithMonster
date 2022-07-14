extends Area2D

var isPlayerHolding = false

func _ready():
	print(get_node("/root/Node2D/Caldo-player").get_position())
	pass
	
func initIngrName(ingr_name):
	print(ingr_name)


func _on_ingredientdrop_area_entered(area):
	if area.get_name() == "caldo-area" :
		isPlayerHolding = true

func _process(_delta):
	if isPlayerHolding:
		set_position(get_node("/root/Node2D/Caldo-player").get_position()+Vector2(50,0))
