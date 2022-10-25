extends KinematicBody2D

signal customer_satisfied(col,row)

var Timer1
var Timer2
var Timer3
var area_being_entered

var init_speed = 3500
var speed = init_speed
var slope_vector
var global_dest_pos_x = 0
var screensize

var global_dish_order = []
var isPassive = true
var isAngry = false

var cust_col
var cust_row
var line_pos

var dest_pos

onready var anim_tree = get_node("Area2D/AnimationTree")
onready var anim_state = anim_tree.get("parameters/playback")

func _ready():
	get_node("Area2D/Sprite").scale.x = -1
	#Timer1 = get_node("Timer")
	#Timer1.connect("timeout", self, "atk_signal")
	#Timer1.set_wait_time(.5)
	Timer2 = get_node("Timer2")
	Timer2.connect("timeout", self, "boredom_signal")
	Timer2.set_wait_time(5.5)
	#Timer3 = get_node("Timer3")
	#Timer3.connect("timeout", self, "teleport_signal")
	#Timer3.set_wait_time(2)
	
	
	
	add_to_group("customers")
	screensize = get_viewport().get_visible_rect().size
	
	line_pos = GlobalVar.organize_line(cust_col,cust_row)
	position = Vector2(screensize.x,line_pos.y)
	
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
		anim_state.travel("walk")
		if position.x <= line_pos.x  :
			set_physics_process(false)
			Timer2.start()
			anim_state.travel("idleTemp")
	
	else :
		#exclusive behavior
		if GlobalVar.countStallDestroyed > 0 :
			dest_pos = get_node("/root/Node2D/YSort/Caldo-player").get_position()
		else :
			dest_pos = get_node("/root/Node2D/StallNodes").get_position()
		#Timer3.start()
		set_physics_process(false)
			
			
	# free when outside screen
	if position.x - 200 > screensize.x :
		queue_free()
		print("cust freed")
		


#when a dish and farm entered
func _on_Area2D_area_entered(area):
	
	if  area.is_in_group("dishes"):
		if global_dish_order.has(area.getDishName()):
			set_physics_process(true)
			global_dish_order.erase(area.getDishName())
			print(global_dish_order)
			
			if global_dish_order == [] :
				get_node("Area2D/Sprite").scale.x = 1
				emit_signal("customer_satisfied",cust_col,cust_row)
				speed *= -1
				get_node("KineCollision").set_deferred("disabled", true)
				isPassive = true
				line_pos *= 0
				get_node("Area2D").set_deferred("monitoring", false)
				get_node("Area2D").set_deferred("monitorable", false)
				Timer2.stop()
				#Timer3.stop()
				
		
		else:
			start_preAngry()
				
	elif area.is_in_group("ingredients"):
		start_preAngry()
		
	#print (area)
	if area.is_in_group("farm_set"):
		area_being_entered = area

#when farm exited to stop	
func _on_Area2D_area_exited(area):
	if area.is_in_group("farm_set"):
		print("exit" , area)
		#Timer1.stop()

#execute to attack farm
func atk_signal():
	
	if area_being_entered != null :
		if area_being_entered.is_in_group("farm_set"):
			GlobalVar.emit_signal("attack",10)
	
	if GlobalVar.countStallDestroyed > 0 :
		dest_pos = get_node("/root/Node2D/YSort/Caldo-player").get_position()
		
#customer cant wait
func boredom_signal():
	start_preAngry()
	
#customer cant wait
func teleport_signal():
	#Timer1.start()
	if GlobalVar.countStallDestroyed > 0 :
		position = dest_pos
		dest_pos = get_node("/root/Node2D/YSort/Caldo-player").get_position()
	else :
		dest_pos = get_node("/root/Node2D/StallNodes").get_position()
		position.x = dest_pos.x
		

#pre-angry animation
func start_preAngry():
	isPassive = false
	set_physics_process(false)
	if speed != 0:
		print("preangry")
		anim_state.travel("angry")
		speed=0
		Timer2.stop()
		

func preAngryFinished():
	print ("anim finished")
	anim_state.travel("atk")
	speed = init_speed
	set_physics_process(true)



