extends Area2D

signal ingredient_freed(ingr_name_freed)

var isPlayerHolding = false
var isPlayerThrowing = false
var isClickOnRight = true
var global_ingr_name = null

var hold_pos = 50
var speed = 1000

var screensize
var slope_vector
var current_player_holding_size

func _ready():
	screensize = get_viewport_rect().size
	pass
	
#for initializing the ingredient tyoe
func initIngrName(ingr_name):
	global_ingr_name = ingr_name
	print(ingr_name)
	match global_ingr_name :
		"egg" :
			get_node("Sprite").set_texture(preload("res://ImageAssets/egg_ingr.png"))
		"pork" :
			get_node("Sprite").set_texture(preload("res://ImageAssets/pork_ingr.png"))
		"wheat" :
			get_node("Sprite").set_texture(preload("res://ImageAssets/wheat_ingr.png"))
		"squid" :
			get_node("Sprite").set_texture(preload("res://ImageAssets/squid_ingr.png"))

#for getting the ingredient type
func getIngrName():
	return global_ingr_name

#when caldo picked the ingredient 
func _on_ingredientdrop_area_entered(area):
	if area.get_name() == "caldo-area" && !isPlayerThrowing && GlobalVar.player_holding.size() < 2 && GlobalVar.player_dish_holding == null:	
		set_deferred("monitoring",false)
		set_deferred("monitorable",false)
		current_player_holding_size = GlobalVar.player_holding.size()
		isPlayerHolding = true
		GlobalVar.player_holding.append(global_ingr_name)
	elif area.is_in_group("customers") and !area.is_in_group("bullet"): 
		isPlayerHolding = false
		GlobalVar.player_holding.erase(global_ingr_name)
		emit_signal("ingredient_freed",global_ingr_name)
		queue_free()
		

func _process(delta):
	#for smart holding and throwing
	if isPlayerHolding && !isPlayerThrowing:
		if current_player_holding_size == 0:
			set_position(get_node("/root/Node2D/Caldo-player").get_position()+Vector2(hold_pos,0))
		else :
			set_position(get_node("/root/Node2D/Caldo-player").get_position()+Vector2(-hold_pos,0))
	elif !isPlayerHolding && isPlayerThrowing:
		if isClickOnRight:
			set_position(position + Vector2(1,-1) * slope_vector * speed * delta)
		else:
			set_position(position + Vector2(-1,1) * slope_vector * speed * delta)
		
	#destroy when outside the screen
	if position.x - 100 > screensize.x || position.x + 100 < 0 || position.y + 100 < 0 || position.y - 100 > screensize.y:
		emit_signal("ingredient_freed",global_ingr_name)
		queue_free()
		
	#destroy when cooked
	if GlobalVar.isPlayerCooking && global_ingr_name in GlobalVar.player_holding:
		GlobalVar.player_holding.erase(global_ingr_name)
		emit_signal("ingredient_freed",global_ingr_name)
		if GlobalVar.player_holding == []:
			GlobalVar.isPlayerCooking = false
		queue_free()
		
#for left clicking
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && isPlayerHolding:
			if event.pressed:
				set_deferred("monitoring",true)
				set_deferred("monitorable",true)
				
				GlobalVar.player_holding.clear()
				isPlayerHolding = false
				isPlayerThrowing = true
				isClickOnRight = event.position.x > position.x
				
				slope_vector = GlobalVar.slope_calculate(position,event.position)
