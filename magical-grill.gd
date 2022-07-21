extends StaticBody2D

signal player_cooking(DishStatus)

func _ready():
	pass

#when grill entered
func _on_Area2D_area_entered(area):
	if(area.get_name() == "caldo-area"):
		
		var isDishAvailable = true
		match GlobalVar.player_holding :
			["pork","wheat"], ["wheat","pork"]:
				GlobalVar.player_dish_holding = "MeatBalls"
				print("MeatBalls")
			_:
				isDishAvailable = false
				print("None")
		
		
		
		
		emit_signal("player_cooking",isDishAvailable)
		
		print("cooking")
