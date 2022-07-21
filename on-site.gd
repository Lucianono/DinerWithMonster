extends Node


onready var ingr = preload("res://ingredient-entity.tscn")

var coop_position
var butcher_position
var field_position
var pond_positon

var isEggFreed = true
var isPorkFreed = true
var isWheatFreed = true
var isSquidFreed = true

func _ready():
	coop_position = get_node("Coop").get_position()
	butcher_position = get_node("Butcher").get_position()
	field_position = get_node("Field").get_position()
	pond_positon = get_node("Pond").get_position()
	randomize()
	set_process(true)
	

#when coop touched (signal)
func _on_Coop_coop_entered():
	if isEggFreed:
		
		var ingr_ent = ingr.instance()
		ingr_ent.initIngrName("egg")
		ingr_ent.connect("ingredient_freed",self,"_on_ingredientdrop_ingredient_freed")
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(coop_position + Vector2(20,50))
		isEggFreed = false
		

#when butcher touched (signal)
func _on_Butcher_butcher_entered():
	if isPorkFreed:
		
		var ingr_ent = ingr.instance()
		ingr_ent.initIngrName("pork")
		ingr_ent.connect("ingredient_freed",self,"_on_ingredientdrop_ingredient_freed")
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(butcher_position + Vector2(20,-50))
		isPorkFreed = false
		

func _on_Field_field_entered():
	if isWheatFreed:
		
		var ingr_ent = ingr.instance()
		ingr_ent.initIngrName("wheat")
		ingr_ent.connect("ingredient_freed",self,"_on_ingredientdrop_ingredient_freed")
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(field_position + Vector2(20,-50))
		isWheatFreed = false


func _on_Pond_pond_entered():
	if isSquidFreed:
		
		var ingr_ent = ingr.instance()
		ingr_ent.initIngrName("squid")
		ingr_ent.connect("ingredient_freed",self,"_on_ingredientdrop_ingredient_freed")
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(pond_positon + Vector2(20,50))
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

