extends StaticBody2D

signal field_entered

var hp = 20
var isCustAttacking = false
var isPlayerClose = false
var isFarmDestroyed = false

func _ready():
	var _x = GlobalVar.connect("attack",self,"_on_attack")

#when caldo touch wheat
func _on_Area2D_area_entered(area):
	if(area.get_name() == "caldo-area"):
		isPlayerClose = true
		if !isFarmDestroyed:
			emit_signal("field_entered")
	if area.is_in_group("customers") :
		isCustAttacking = true

func _on_Area2D_area_exited(area):
	if area.is_in_group("customers") :
		isCustAttacking = false
	if area.get_name() == "caldo-area":
		isPlayerClose = false

func _on_attack(atk):
	if isCustAttacking:
		hp -= atk
		print(hp)
		if hp <= 0 :
			hp = clamp (hp,0,20)
			farm_state(true , hp , Vector2(0.2,0.2))
			
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and isPlayerClose and hp < 20:
		if event.scancode == KEY_SPACE:
			print("stall fixed")
			farm_state(false  , 20, Vector2(0.285,0.285))
			
func farm_state(collision , hpset, scaleA):
	hp=hpset
	$CollisionShape2D.set_deferred("disabled", collision)
	isFarmDestroyed = collision
	$Area2D/Sprite.scale = scaleA
