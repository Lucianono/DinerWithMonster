extends Node

signal attack(atk)

var total_repair_points
@onready var repair_label = get_node("/root/Node2D/HUD/Label")

var player_holding = []
var player_dish_holding = null
var isPlayerCooking = false

var screensize
@onready var stall_obj

var repair_timer
var countStallDestroyed = 0

func _ready():
	repair_timer = get_node("/root/GlobalScene/Timer")
	repair_timer.start()
	total_repair_points = 100
	repair_label.set_text("Repair Points : " + str(total_repair_points))
	
	screensize = get_viewport().get_visible_rect().size
	print(screensize)
	set_physics_process(false)
	pass

func _physics_process(delta):
	pass
	
func slope_calculate(first_pos,last_pos):
	#warning divided by 0
	var slope = (first_pos.y - last_pos.y)/(last_pos.x - first_pos.x)
	var slope_vector = Vector2(1, slope).normalized()
	return slope_vector


func organize_line(col,row):
	
	var destination_pos = Vector2()
	match col:
		0:
			destination_pos.x = stall_obj.position.x
		1:
			destination_pos.x = (screensize.x - stall_obj.position.x)/3 + stall_obj.position.x
		2:
			destination_pos.x = (2 * (screensize.x - stall_obj.position.x)/3) + stall_obj.position.x
		_:
			destination_pos.x = screensize.x + 400
				
	match row:
		0:
			destination_pos.y = 0
		1:
			destination_pos.y = 2*stall_obj.get_node("CollisionShape2D").shape.size.y/4
		2:
			destination_pos.y = 2*stall_obj.get_node("CollisionShape2D").shape.size.y/2
		3:
			destination_pos.y = 3 * 2*stall_obj.get_node("CollisionShape2D").shape.size.y/4
		_:
			destination_pos.y = -200
	
	
	#center y pos		
	if col != null and row != null:
		destination_pos.y += ((screensize.y - 2*stall_obj.get_node("CollisionShape2D").shape.size.y) / 2) + 16
		destination_pos.x += 40
		
	return(destination_pos)


func repair_farm(hpmax,hpcurr):
	total_repair_points -= hpmax - hpcurr
	repair_label.set_text("Repair Points : " + str(total_repair_points))



#===============
#wat
func rp_add_pts():
	if GlobalVar.total_repair_points < 100 :
		GlobalVar.total_repair_points += 1
		repair_label.set_text("Repair Points : " + str(GlobalVar.total_repair_points))


func rp_timer_signal():
	rp_add_pts()
