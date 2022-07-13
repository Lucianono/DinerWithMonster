extends Node

#this is me

onready var ingr = preload("res://ingredient-entity.tscn")
onready var coop = preload("res://egg-coop.tscn")
var coop_position

func _ready():
	coop_position = get_node("Coop").get_position()
	print(coop_position)
	randomize()
	set_process(true)
	

func _on_Coop_coop_entered():
	var ingr_ent = ingr.instance()
	call_deferred("add_child",ingr_ent)
	ingr_ent.set_position(coop_position + Vector2(20,50))
	print("caldo_entered")
	
