extends KinematicBody2D

signal customer_satisfied(col,row)

var Timer1
var Timer2
var area_being_entered

var speed =7000
var slope_vector
var global_dest_pos_x = 0
var screensize

var global_dish_order = []
var isPassive = true
var isAngryable = true

var cust_col
var cust_row
var line_pos


func _ready():
	Timer1 = get_node("Timer")
	Timer1.connect("timeout", self, "atk_signal")
	Timer1.set_wait_time(1)
	Timer2 = get_node("Timer2")
	Timer2.connect("timeout", self, "boredom_signal")
	Timer2.set_wait_time(1)
	
	
	add_to_group("customers")
	screensize = get_viewport_rect().size
	
	line_pos = GlobalVar.organize_line(cust_col,cust_row)
	position = Vector2(screensize.x,line_pos.y+70)
	
	set_physics_process(true)
	
	if line_pos.x > screensize.x+200:
		position = Vector2(1400,1)

#initialize index from arr_cust_line
func initCustIndex(col,row):
	cust_col = col
	cust_row = row
	
	line_pos = GlobalVar.organize_line(cust_col,cust_row)
	set_physics_process(true)

#initialize dish order
func initFoodOrder(dish):
	global_dish_order = dish
	print(global_dish_order)
	
	
func _physics_process(delta):
	# when customer is passive or angry
	if isPassive:
		move_and_slide(Vector2(-1,0) * speed * delta)
		if position.x <= line_pos.x+100 and isAngryable:
			
			set_physics_process(false)
			Timer2.start()
	
	else :
		#exclusive behavior
		var isPlayerOnRight = get_node("/root/Node2D/Caldo-player").get_position().x > position.x
		slope_vector = GlobalVar.slope_calculate(position,get_node("/root/Node2D/Caldo-player").get_position())
		
		#for smart following
		if isPlayerOnRight:
			move_and_slide(Vector2(1,-1) * slope_vector * speed * delta)
		else:
			move_and_slide(Vector2(-1,1) * slope_vector * speed * delta)
			
	# free when outside screen
	if position.x - 200 > screensize.x :
		queue_free()
		print("cust freed")
		


#when a dish and farm entered
func _on_Area2D_area_entered(area):
	
	if  area.is_in_group("dishes"):
		set_physics_process(true)
		if global_dish_order.has(area.getDishName()):
			global_dish_order.erase(area.getDishName())
			print(global_dish_order)
			
			if global_dish_order == [] :
				emit_signal("customer_satisfied",cust_col,cust_row)
				speed *= -1
				get_node("KineCollision").set_deferred("disabled", true)
				isPassive = true
				line_pos *= 0
				get_node("Area2D").set_deferred("monitoring", false)
				get_node("Area2D").set_deferred("monitorable", false)
				Timer2.stop()
		
		else:
			isPassive = false
				
	elif area.is_in_group("ingredients"):
		set_physics_process(true)
		isPassive = false
		
	#print (area)
	if area.is_in_group("farm_set"):
		area_being_entered = area
		Timer1.start()

#when farm exited to stop	
func _on_Area2D_area_exited(area):
	if area.is_in_group("farm_set"):
		print("exit" , area)
		Timer1.stop()

#execute to attack farm
func atk_signal():
	if area_being_entered.is_in_group("farm_set"):
		GlobalVar.emit_signal("attack",5)

#customer cant wait
func boredom_signal():
	set_physics_process(true)
	isPassive = false



