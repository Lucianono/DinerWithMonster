extends StaticBody2D

signal player_cooking

var dish_created

func _ready():
	pass

#when grill entered
func _on_Area2D_area_entered(area):
	if(area.get_name() == "caldo-area"):
		
		match GlobalVar.player_dish_holding :
			["pork","wheat"], ["wheat","pork"]:
				dish_created = "MeatBalls"
				print("MeatBalls")
			_:
				dish_created = null
				print("None")
		
		
		
		
		emit_signal("player_cooking")
		
		print("cooking")
