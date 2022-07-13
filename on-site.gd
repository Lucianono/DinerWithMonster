extends Node


onready var ingr_ent = preload("res://ingredient-entity.tscn")

func _ready():
	set_process(true)
	

func _on_Coop_coop_entered():
	print("caldo_entered")
	
