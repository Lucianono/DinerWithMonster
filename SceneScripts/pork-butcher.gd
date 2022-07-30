extends StaticBody2D

signal butcher_entered

var hp = 20
var isCustAttacking = false
var isPlayerClose = false
var isFarmDestroyed = false

onready var health_bar = $ProgressBar

func _ready():
	health_bar.visible = false
	var _x = GlobalVar.connect("attack",self,"_on_attack")
	health_bar.value = hp

#when caldo touch butcher
func _on_Area2D_area_entered(area):
	if(area.get_name() == "caldo-area"):
		isPlayerClose = true
		if !isFarmDestroyed:
			emit_signal("butcher_entered")
	if area.is_in_group("customers") :
		isCustAttacking = true

func _on_Area2D_area_exited(area):
	if area.is_in_group("customers") :
		isCustAttacking = false
	if area.get_name() == "caldo-area":
		isPlayerClose = false

#atk signal from customers
func _on_attack(atk):
	if isCustAttacking and hp>0:
		health_bar.visible = true
		hp -= atk
		if hp <= 0 :
			hp=0
			print(hp)
			farm_state(true ,hp)
		health_bar.value = hp
	
#spacebar to fix		
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and isPlayerClose and hp < 20  and GlobalVar.total_repair_points >= (20-hp):
		if event.scancode == KEY_SPACE:
			print(get_name()," fixed")
			GlobalVar.repair_farm(20, hp)
			farm_state(false ,20)
			health_bar.visible = false
			
func farm_state(collision , hpset):
	hp=hpset
	$CollisionShape2D.set_deferred("disabled", collision)
	isFarmDestroyed = collision
	health_bar.value = hp

