extends StaticBody2D

signal field_entered

func _ready():
	pass

#when caldo touch wheat
func _on_Area2D_area_entered(area):
	if(area.get_name() == "caldo-area"):
		emit_signal("field_entered")

