extends Area2D

signal ingredient_freed(ingr_name_freed)

var isPlayerHolding = false
var isPlayerThrowing = false
var isClickOnRight = true
var global_ingr_name = null

var hold_pos = 50
var speed = 1000

var screensize
var slope
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
			get_node("Sprite").set_texture(preload("res://a3.png"))
		"pork" :
			get_node("Sprite").set_texture(preload("res://a2.png"))
		"wheat" :
			get_node("Sprite").set_texture(preload("res://a4.png"))
		"squid" :
			get_node("Sprite").set_texture(preload("res://a5.png"))

#for getting the ingredient type
func getIngrName():
	return global_ingr_name

#when caldo picked the ingredient 
func _on_ingredientdrop_area_entered(area):
	if area.get_name() == "caldo-area" && !isPlayerThrowing && GlobalVar.player_holding.size() < 2 && GlobalVar.player_dish_holding == null:	
		disconnect("area_entered",self,"_on_ingredientdrop_area_entered")
		current_player_holding_size = GlobalVar.player_holding.size()
		isPlayerHolding = true
		GlobalVar.player_holding.append(global_ingr_name)
		

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
		
#for left clicking
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && isPlayerHolding:
			if event.pressed:
				
				GlobalVar.player_holding.clear()
				isPlayerHolding = false
				isPlayerThrowing = true
				isClickOnRight = event.position.x > position.x
				
				#may math sht for aiming sht AHHAHAHHAHA
				slope = (position.y - event.position.y)/(event.position.x - position.x)
				slope_vector = Vector2(1, slope).normalized()
				print(slope_vector)
