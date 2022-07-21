extends StaticBody2D

signal butcher_entered

func _ready():
	pass

#when caldo touch butcher
func _on_Area2D_area_entered(area):
	if(area.get_name() == "caldo-area"):
		emit_signal("butcher_entered")

