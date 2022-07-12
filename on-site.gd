extends Node

onready var ingr_ent = preload("res://ingredient-entity.tscn")

func _ready():
	var ingr = ingr_ent.instance()
	get_node("Node2D").connect("coop_entered",self,"on_coop_entered")
	print("ready")
	on_coop_entered()
	
func on_coop_entered():
	print("caldo_entered")
