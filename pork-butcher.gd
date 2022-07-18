extends StaticBody2D

signal butcher_entered

func _ready():
	pass

#when caldo touch coop
func _on_Area2D_area_entered(area):
	if(area.get_name() == "caldo-area"):
		emit_signal("butcher_entered")
		
		print(area.get_name())

