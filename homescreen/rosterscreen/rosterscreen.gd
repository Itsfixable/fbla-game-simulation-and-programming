extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MoneyLabel.text = "$%d" % GameState.budget
	$Train.pressed.connect(_on_Train_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_Train_pressed() -> void:
	print("train  button clicked")
	get_tree().change_scene_to_file("res://homescreen/rosterscreen/trainscreen/trainscreen.tscn")
