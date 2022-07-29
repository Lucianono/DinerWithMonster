extends Node

signal attack(atk)

var total_repair_points

var player_holding = []
var player_dish_holding = null
var isPlayerCooking = false

var screensize
var stall_position

func _ready():
	total_repair_points = 100
	screensize = get_viewport().size
	set_process(false)
	pass

func _process(_delta):
	print(player_holding)
	
	
func slope_calculate(first_pos,last_pos):
	#warning divided by 0
	var slope = (first_pos.y - last_pos.y)/(last_pos.x - first_pos.x)
	var slope_vector = Vector2(1, slope).normalized()
	return slope_vector


func organize_line(col,row):
	
	var destination_pos = Vector2()
	match col:
		0:
			destination_pos.x = stall_position.x
		1:
			destination_pos.x = (screensize.x - stall_position.x)/3 + stall_position.x
		2:
			destination_pos.x = (2 * (screensize.x - stall_position.x)/3) + stall_position.x
		_:
			destination_pos.x = screensize.x + 400
				
	match row:
		0:
			destination_pos.y = 0
		1:
			destination_pos.y = screensize.y/4
		2:
			destination_pos.y = screensize.y/2
		3:
			destination_pos.y = 3 * screensize.y/4
		_:
			destination_pos.y = -200
				
	return(destination_pos)

func repair_farm(hpmax,hpcurr):
	get_node("/root/Node2D/HUD/Label").set_text("Repair Points : " + str(total_repair_points))
	total_repair_points -= hpmax - hpcurr
	return total_repair_points
