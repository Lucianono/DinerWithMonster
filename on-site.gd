extends Node


onready var ingr = preload("res://ingredient-entity.tscn")
var coop_position
var butcher_position
var ingr_ent

func _ready():
	coop_position = get_node("Coop").get_position()
	butcher_position = get_node("Butcher").get_position()
	randomize()
	set_process(true)
	

#when coop touched (signal)
func _on_Coop_coop_entered():
	if !is_instance_valid(ingr_ent):	
		ingr_ent = ingr.instance()
		
	if !ingr_ent.getIngrName() == "egg" :
		ingr_ent = ingr.instance()
		ingr_ent.initIngrName("egg")
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(coop_position + Vector2(20,50))
	
	print("caldo_entered")
	



func _on_Butcher_butcher_entered():
	if !is_instance_valid(ingr_ent):	
		ingr_ent = ingr.instance()
	
	if !ingr_ent.getIngrName() == "pork" :	
		ingr_ent = ingr.instance()
		ingr_ent.initIngrName("pork")
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(butcher_position + Vector2(20,-50))
	print("caldo_entered") 
