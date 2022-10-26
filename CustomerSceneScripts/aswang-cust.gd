extends KinematicBody2D

signal customer_satisfied(col,row)

var Timer1
var Timer2
var area_being_entered

var init_speed = 3500
var speed = init_speed
var slope_vector
var global_dest_pos_x = 0
var screensize

var global_dish_order = []
var dish_disp_nodes = []
var isPassive = true
var isAngryable = true

var cust_col
var cust_row
var line_pos

onready var wait_pb = get_node("ProgressBar")
onready var anim_tree = get_node("Area2D/AnimationTree")
onready var anim_state = anim_tree.get("parameters/playback")

func _ready():
	var cust_max_wait_time = 7
	
	get_node("Area2D/Sprite").scale.x = -1
	wait_pb.max_value = cust_max_wait_time
	Timer2 = get_node("Timer2")
	Timer2.connect("timeout", self, "boredom_signal")
	Timer2.set_wait_time(cust_max_wait_time)
	
	
	add_to_group("customers")
	screensize = get_viewport().get_visible_rect().size
	
	line_pos = GlobalVar.organize_line(cust_col,cust_row)
	position = Vector2(screensize.x,line_pos.y)
	
	set_physics_process(true)
	set_process(false)
	
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
	
	for i in global_dish_order.size():
		print("hiho")
		var dish_node = TextureRect.new();
		dish_node.set_name(global_dish_order[i])
		
		match global_dish_order[i] :
			"Adobo" :
				dish_node.set_texture(preload("res://ImageAssets/dish/adobo_dish.png"))
			"Pandesal" :
				dish_node.set_texture(preload("res://ImageAssets/dish/pandesal_dish.png"))
			"Balot" :
				dish_node.set_texture(preload("res://ImageAssets/dish/balot_dish.png"))
			"Betamax" :
				dish_node.set_texture(preload("res://ImageAssets/dish/betamax_dish.png"))
			"MeatBalls" :
				dish_node.set_texture(preload("res://ImageAssets/dish/mball_dish.png"))
			"Relleno" :
				dish_node.set_texture(preload("res://ImageAssets/dish/relleno_dish.png"))
			"Sisig" :
				dish_node.set_texture(preload("res://ImageAssets/dish/sisig_dish.png"))
			"SquidBalls" :
				dish_node.set_texture(preload("res://ImageAssets/dish/sball_dish.png"))
			"Tokneneng" :
				dish_node.set_texture(preload("res://ImageAssets/dish/tokneneng_dish.png"))
			"Calamares" :
				dish_node.set_texture(preload("res://ImageAssets/dish/calamares_dish.png"))

		$CenterContainer/PanelContainer/Node2D.add_child(dish_node)
	
	
	
func _physics_process(delta):
	# when customer is passive or angry
	if isPassive:
		move_and_slide(Vector2(-1,0) * speed * delta)
		anim_state.travel("walk")
		if position.x <= line_pos.x:
			$CenterContainer.visible = true 
			set_physics_process(false)
			Timer2.start()
			set_process(true)
			anim_state.travel("idleTemp")
	
	else :
		#exclusive behavior
		var isPlayerOnRight = get_node("/root/Node2D/YSort/Caldo-player").get_position().x > position.x
		slope_vector = GlobalVar.slope_calculate(position,get_node("/root/Node2D/YSort/Caldo-player").get_position())
		
		#for smart following
		if isPlayerOnRight:
			move_and_slide(Vector2(1,-1) * slope_vector * speed * delta)
			get_node("Area2D/Sprite").scale.x = 1
		else:
			move_and_slide(Vector2(-1,1) * slope_vector * speed * delta)
			get_node("Area2D/Sprite").scale.x = -1
			
	# free when outside screen
	if position.x - 20 > screensize.x :
		queue_free()
		print("cust freed")
		
# for pb display
func _process (delta):
	wait_pb.value = Timer2.time_left


#when a dish and farm entered
func _on_Area2D_area_entered(area):
	
	if  area.is_in_group("dishes"):
		speed = init_speed
		if global_dish_order.has(area.getDishName()):
			set_physics_process(true)
			global_dish_order.erase(area.getDishName())
			$CenterContainer/PanelContainer/Node2D.get_node(area.getDishName()).queue_free()
			print(global_dish_order)
			
			
			if global_dish_order == [] :
				$CenterContainer.visible = false 
				anim_state.travel("walk")
				emit_signal("customer_satisfied",cust_col,cust_row)
				speed *= -1
				get_node("KineCollision").set_deferred("disabled", true)
				isPassive = true
				get_node("Area2D/Sprite").scale.x = 1
				line_pos *= 0
				get_node("Area2D").set_deferred("monitoring", false)
				get_node("Area2D").set_deferred("monitorable", false)
				Timer2.stop()
		
		else:
			start_preAngry()
				
	elif area.is_in_group("ingredients"):
		start_preAngry()
		
	#print (area)
	if area.is_in_group("farm_set"):
		area_being_entered = area
		#Timer1.start()
		anim_state.travel("atk")

#when farm exited to stop	
func _on_Area2D_area_exited(area):
	if area.is_in_group("farm_set") and !isPassive:
		print("exit" , area)
		anim_state.travel("angrywalk")
		#Timer1.stop()

#execute to attack farm
func atk_signal():
	if area_being_entered.is_in_group("farm_set"):
		GlobalVar.emit_signal("attack",5)

#customer cant wait
func boredom_signal():
	start_preAngry()

#pre-angry animation
func start_preAngry():
	set_process(false)
	isPassive = false
	if speed != 0:
		print("preangry")
		anim_state.travel("angry")
		speed=0
		Timer2.stop()

func preAngryFinished():
	print ("anim finished")
	speed = init_speed
	anim_state.travel("angrywalk")
	set_physics_process(true)
