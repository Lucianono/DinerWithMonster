extends Area2D

onready var mainPlayer = preload("res://main-sprite.tscn")
var isPlayerHolding = false

func _ready():
	print(get_tree().get_root().get_node("Caldo-player").get_position())
	pass


func _on_ingredientdrop_area_entered(area):
	if area.get_name() == "caldo-area" :
		isPlayerHolding = true
		print("wow")

func _process(_delta):
	if isPlayerHolding:
		set_position(get_position() + mainPlayer.instance().get_position() + Vector2(2,2))
