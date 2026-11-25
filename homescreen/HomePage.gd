extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set budget
	$MoneyLabel.text = "$%d" % GameState.budget
	
	#set player roster as a label
	var text := ""
	for player_name in GameState.roster:
		text += player_name + "\n"       
	$RosterList.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_roster_pressed() -> void:
	get_tree().change_scene_to_file("res://rosterscreen/rosterscreen.tscn")


	
