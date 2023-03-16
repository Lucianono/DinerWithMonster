extends Area2D

signal dish_freed(dish_name_freed)

var isPlayerHolding = false
var isPlayerThrowing = false
var isClickOnRight = true
var global_dish_name = null

var hold_pos = 30
var speed = 500

var screensize
var slope_vector

func _ready():
	add_to_group("dishes")
	screensize = get_viewport_rect().size
	pass
	
#for initializing the ingredient tyoe
func initDishName(dish_name):
	global_dish_name = dish_name
	match global_dish_name :
		"Adobo" :
			get_node("Sprite2D").set_texture(preload("res://ImageAssets/dish/adobo_dish.png"))
		"Pandesal" :
			get_node("Sprite2D").set_texture(preload("res://ImageAssets/dish/pandesal_dish.png"))
		"Balot" :
			get_node("Sprite2D").set_texture(preload("res://ImageAssets/dish/balot_dish.png"))
		"Betamax" :
			get_node("Sprite2D").set_texture(preload("res://ImageAssets/dish/betamax_dish.png"))
		"MeatBalls" :
			get_node("Sprite2D").set_texture(preload("res://ImageAssets/dish/mball_dish.png"))
		"Relleno" :
			get_node("Sprite2D").set_texture(preload("res://ImageAssets/dish/relleno_dish.png"))
		"Sisig" :
			get_node("Sprite2D").set_texture(preload("res://ImageAssets/dish/sisig_dish.png"))
		"SquidBalls" :
			get_node("Sprite2D").set_texture(preload("res://ImageAssets/dish/sball_dish.png"))
		"Tokneneng" :
			get_node("Sprite2D").set_texture(preload("res://ImageAssets/dish/tokneneng_dish.png"))
		"Calamares" :
			get_node("Sprite2D").set_texture(preload("res://ImageAssets/dish/calamares_dish.png"))
	print(dish_name)

#for getting the ingredient type
func getDishName():
	return global_dish_name

#when caldo picked the ingredient 
func _on_dishready_area_entered(area):
	if area.get_name() == "caldo-area" && !isPlayerThrowing && GlobalVar.player_dish_holding == null && GlobalVar.player_holding == []:	
		set_deferred("monitoring",false)
		set_deferred("monitorable",false)
		isPlayerHolding = true
		GlobalVar.player_dish_holding = global_dish_name
	elif area.is_in_group("customers") and !area.is_in_group("bullet"): 
		emit_signal("dish_freed",global_dish_name)
		GlobalVar.player_dish_holding = null
		queue_free()

func _process(delta):
	#for smart holding and throwing
	if isPlayerHolding && !isPlayerThrowing:
		set_position(get_node("/root/Node2D/Node2D/Caldo-player").get_position()+Vector2(0,-hold_pos))
	elif !isPlayerHolding && isPlayerThrowing:
		if isClickOnRight:
			set_position(position + Vector2(1,-1) * slope_vector * speed * delta)
		else:
			set_position(position + Vector2(-1,1) * slope_vector * speed * delta)
		
	#destroy when outside the screen
	if position.x - 100 > screensize.x || position.x + 100 < 0 || position.y + 100 < 0 || position.y - 100 > screensize.y:
		emit_signal("dish_freed",global_dish_name)
		queue_free()
		
#for left clicking
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && isPlayerHolding:
			if event.pressed:
				set_deferred("monitoring",true)
				set_deferred("monitorable",true)
				
				GlobalVar.player_dish_holding = null
				isPlayerHolding = false
				isPlayerThrowing = true
				isClickOnRight = event.position.x > position.x
				
				
				slope_vector = GlobalVar.slope_calculate(position,event.position)


