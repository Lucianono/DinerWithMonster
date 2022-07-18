extends StaticBody2D

signal slaughter_entered

func _ready():
	pass

#when caldo touch coop
func _on_Area2D_area_entered(area):
	if(area.get_name() == "caldo-area"):
		emit_signal("slaughter_entered")
		
		print(area.get_name())

