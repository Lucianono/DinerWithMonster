extends KinematicBody2D

signal customer_satisfied

var speed = 10000
var slope_vector
var global_dest_pos_x = 0
var screensize

var global_dish_order = []
var isPassive = true
var isAngry = false


func _ready():
	screensize = get_viewport_rect().size
	set_physics_process(true)
	pass

func initPositions(dest_pos_x):
	global_dest_pos_x = dest_pos_x
	
func initFoodOrder(dish):
	global_dish_order = dish
	print(global_dish_order)
	pass
	
func _physics_process(delta):
	
	if isPassive:
		move_and_slide(Vector2(-1,0) * speed * delta)
		position.x = clamp(position.x,global_dest_pos_x,screensize.x+300)
	
	else :
		var isPlayerOnRight = get_node("/root/Node2D/Caldo-player").get_position().x > position.x
		slope_vector = GlobalVar.slope_calculate(position,get_node("/root/Node2D/Caldo-player").get_position())
		
		#for smart following
		if isPlayerOnRight:
			move_and_slide(Vector2(1,-1) * slope_vector * speed * delta)
		else:
			move_and_slide(Vector2(-1,1) * slope_vector * speed * delta)
			
	if position.x - 200 > screensize.x :
		queue_free()
		print("cust freed")
		


func _on_Area2D_area_entered(area):
	if  area.is_in_group("dishes"):
		
		if global_dish_order.has(area.getDishName()):
			global_dish_order.erase(area.getDishName())
			print(global_dish_order)
			
			if global_dish_order == [] :
				emit_signal("customer_satisfied")
				speed *= -1
				get_node("KineCollision").set_deferred("disabled", true)
			
		
