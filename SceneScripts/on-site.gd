extends Node


@onready var ingr = preload("res://SceneScripts/ingredient-entity.tscn")
@onready var dish = preload("res://SceneScripts/dish-entity.tscn")
var screensize

var coop_position
var butcher_position
var field_position
var pond_positon
var grill_postion

var isEggFreed = true
var isPorkFreed = true
var isWheatFreed = true
var isSquidFreed = true

var cust_column = 3
var cust_row = 4

func _ready():
	screensize = get_viewport().get_visible_rect().size

	coop_position = get_node("Node2D/Coop").get_position()
	butcher_position = get_node("Node2D/Butcher").get_position()
	field_position = get_node("Node2D/Field").get_position()
	pond_positon = get_node("Node2D/Pond").get_position()
	grill_postion = get_node("Node2D/Grill").get_position()
	
	stall_obj = get_node("StallNodes")
	GlobalVar.stall_obj = stall_obj
	
	randomize()
	set_process(true)
	
	#2d array
	for i in cust_column:
		arr_cust_line.append([])
		for j in cust_row:
			arr_cust_line[i].append(null)

#when coop touched (signal)
func _on_Coop_coop_entered():
	if isEggFreed:
		
		var ingr_ent = ingr.instantiate()
		ingr_ent.initIngrName("egg")
		ingr_ent.connect("ingredient_freed",Callable(self,"_on_ingredientdrop_ingredient_freed"))
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(coop_position + Vector2(10,25))
		isEggFreed = false
		
#when butcher touched (signal)
func _on_Butcher_butcher_entered():
	if isPorkFreed:
		
		var ingr_ent = ingr.instantiate()
		ingr_ent.initIngrName("pork")
		ingr_ent.connect("ingredient_freed",Callable(self,"_on_ingredientdrop_ingredient_freed"))
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(butcher_position + Vector2(10,-25))
		isPorkFreed = false
		
#when field touched (signal)
func _on_Field_field_entered():
	if isWheatFreed:
		
		var ingr_ent = ingr.instantiate()
		ingr_ent.initIngrName("wheat")
		ingr_ent.connect("ingredient_freed",Callable(self,"_on_ingredientdrop_ingredient_freed"))
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(field_position + Vector2(10,-25))
		isWheatFreed = false

#when pond touched (signal)
func _on_Pond_pond_entered():
	if isSquidFreed:
		
		var ingr_ent = ingr.instantiate()
		ingr_ent.initIngrName("squid")
		ingr_ent.connect("ingredient_freed",Callable(self,"_on_ingredientdrop_ingredient_freed"))
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(pond_positon + Vector2(10,25))
		isSquidFreed = false

#when ingredient freed
func _on_ingredientdrop_ingredient_freed(ingr_name_freed):
	print("ingr freed")
	match ingr_name_freed:
		"egg" :
			isEggFreed = true
		"pork" :
			isPorkFreed = true
		"wheat" :
			isWheatFreed = true
		"squid" :
			isSquidFreed = true

#====================================
#Cooking

#when Grill entered (signal)
func _on_Grill_player_cooking(dish_name_created):
	if GlobalVar.player_holding != []:
		print("cooking")
		GlobalVar.isPlayerCooking = true
		var dish_ent = dish.instantiate()
		dish_ent.initDishName(dish_name_created)
		dish_ent.connect("dish_freed",Callable(self,"_on_dishready_dish_freed"))
		call_deferred("add_child",dish_ent)
		randomize()
		dish_ent.set_position(grill_postion + Vector2(randf_range(-10,-15),randf_range(0,30)))
	
#when dish freed
func _on_dishready_dish_freed(_dish_name_freed):
	print("dish freed")


#====================================
#Customer Line

@onready var aswang = preload ("res://CustomerSceneScripts/aswang-cust.tscn")
@onready var whitelady = preload ("res://CustomerSceneScripts/whitelady-cust.tscn")
@onready var tyanak = preload ("res://CustomerSceneScripts/tyanak-cust.tscn")
var arr_cust_line = []
var cust_col_ctr = 0
var stall_obj

var current_row
var current_col
#array declaration on _ready


#for left clicking
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT :
			if event.pressed:
			
				customer_assign()	
				
				
				
func customer_assign():
	randomize()
	var cust_arr = [aswang.instantiate(),whitelady.instantiate(),tyanak.instantiate()]
	#var cust_ent = cust_arr[int(randf_range(0,cust_arr.size()))]
	var cust_ent = cust_arr[0]
	var rand_row
	var basic_dish = ["Adobo","Pandesal","Balot","Betamax"]
	var combo_dish = ["MeatBalls","Relleno","Sisig","SquidBalls","Tokneneng","Calamares"]
	var cust_order_dish = []
				
	for i in 20 :
		if arr_cust_line[cust_col_ctr].has(null) :
			rand_row = int(randf_range(0,cust_row))
			if arr_cust_line[cust_col_ctr][rand_row] == null :
				arr_cust_line[cust_col_ctr][rand_row] = cust_ent
				current_row = rand_row
				cust_ent.initCustIndex(cust_col_ctr,rand_row)
				cust_ent.connect("customer_satisfied",Callable(self,"_on_Aswangenemy_customer_satisfied"))
				$Node2D/Customers.call_deferred("add_child",cust_ent)
				
				#randomize dish order
				for j in randf_range(0,3) :
					if int(randf_range(0,2)) == 0 :
						cust_order_dish.append(basic_dish[randf_range(0,1)])
					else :
						cust_order_dish.append(combo_dish[randf_range(0,1)])
					
				cust_ent.initFoodOrder(cust_order_dish)
				
				break
		else :
			cust_col_ctr+=1
			cust_col_ctr = clamp(cust_col_ctr,0,cust_column-1)
				
		
	

	
func reassemble_line(col,row):
	for i in cust_column - 1:
		if col < cust_column - (i + 1) && arr_cust_line[col+i+1][row] != null :
				
			arr_cust_line[col+i][row] = arr_cust_line[col+i+1][row]
			arr_cust_line[col+i+1][row] = null
			arr_cust_line[col+i][row].initCustIndex(col+i,row)
	
	cust_col_ctr = col
				
				

func _on_Aswangenemy_customer_satisfied(col,row):
	#print(arr_cust_line)
	arr_cust_line[col][row] = null
	reassemble_line(col,row)


#====================================
#HUD
@onready var repair_p = get_node("HUD/Label")
