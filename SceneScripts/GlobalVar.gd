extends Node

var player_holding = []
var player_dish_holding = null
var isPlayerCooking = false

func _ready():
	set_process(false)
	pass

func _process(_delta):
	print(player_holding)
	
	
func slope_calculate(first_pos,last_pos):
	#warning divided by 0
	var slope = (first_pos.y - last_pos.y)/(last_pos.x - first_pos.x)
	var slope_vector = Vector2(1, slope).normalized()
	return slope_vector
