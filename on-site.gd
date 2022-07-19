extends Node


onready var ingr = preload("res://ingredient-entity.tscn")
var coop_position
var butcher_position

var isEggFreed = true
var isPorkFreed = true

func _ready():
	coop_position = get_node("Coop").get_position()
	butcher_position = get_node("Butcher").get_position()
	randomize()
	set_process(true)
	

#when coop touched (signal)
func _on_Coop_coop_entered():
	farm_entered(isEggFreed, "egg", coop_position + Vector2(20,50))
	
func _on_Butcher_butcher_entered():
	farm_entered(isPorkFreed, "pork", butcher_position + Vector2(20,-50))

func _on_ingredientdrop_ingredient_freed(ingr_name_freed):
	print("ingr freed")
	match ingr_name_freed:
		"egg" :
			isEggFreed = true
		"pork" :
			isPorkFreed = true


func farm_entered(isIngrFreed, ingr_name, farm_position):
	if isIngrFreed:
		var ingr_ent = ingr.instance()
		ingr_ent.initIngrName(ingr_name)
		ingr_ent.connect("ingredient_freed",self,"_on_ingredientdrop_ingredient_freed")
		call_deferred("add_child",ingr_ent)
		ingr_ent.set_position(farm_position)
		isIngrFreed = false
		
		
		print(ingr_ent.getIngrName())
