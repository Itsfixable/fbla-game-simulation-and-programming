extends Node2D

var grid: GridContainer


func _ready() -> void:
	grid = $ScrollContainer/CardGrid
	print(grid)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for p in GameState.playerList:
		grid.add_child(make_card(p))


func make_card(p: Dictionary) -> Button:
	var card := Button.new()
	card.custom_minimum_size = Vector2(270, 100)
	card.alignment = HORIZONTAL_ALIGNMENT_LEFT
	card.text = short_text(p)
	card.set_meta("expanded", false)
	card.pressed.connect(_on_card_pressed.bind(card, p))
	return card


func _on_card_pressed(card: Button, p: Dictionary) -> void:
	if card.get_meta("flipping", false):
		return
	card.set_meta("flipping", true)

	var expanded: bool = not card.get_meta("expanded")
	card.set_meta("expanded", expanded)

	card.pivot_offset = card.size / 2

	var tween := create_tween()
	tween.tween_property(card, "scale:x", 0.0, 0.15)
	tween.tween_callback(func():
		card.text = full_text(p) if expanded else short_text(p)
		card.pivot_offset = card.size / 2
	)
	tween.tween_property(card, "scale:x", 1.0, 0.15)
	tween.tween_callback(func(): card.set_meta("flipping", false))


func short_text(p: Dictionary) -> String:
	return "%s  #%d\n%s\nOVERALL: %d" % [
		p["name"], p["number"], p["position"].capitalize(), p["overall"]
	]


func full_text(p: Dictionary) -> String:
	var t := short_text(p) + "\n\n"
	t += "Grade %d  |  Age %d  |  %s-handed\n" % [p["grade"], p["age"], "Left" if p["hand"] == "L" else "Right"]
	t += "Height %d in  |  Weight %d lb\n" % [p["height"], p["weight"]]
	t += "Wingspan %d in  |  Reach %d in\n\n" % [p["wingspan"], p["reach"]]
	t += "Attacking: %d\nDefense: %d\nServing: %d\n" % [p["attacking"], p["defense"], p["serving"]]
	t += "Passing: %d\nSetting: %d\nBlocking: %d" % [p["passing"], p["setting"], p["blocking"]]
	return t
