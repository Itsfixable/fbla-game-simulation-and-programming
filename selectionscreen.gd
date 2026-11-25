extends Node2D

const COLUMNS := 4
const PER_PAGE := 8
const SKILLS := ["attacking", "defense", "serving", "passing", "setting", "blocking"]

var players: Array = GameState.playerList
var page := 0
var page_label := Label.new()
var selected_player: Dictionary = {}
var selected_card: Button

@onready var grid: GridContainer = $CardGrid


func _ready() -> void:
	grid.position = Vector2(20, 70)
	grid.columns = COLUMNS
	make_nav_button("< Prev", Vector2(20, 15), -1)
	make_nav_button("Next >", Vector2(190, 15), 1)
	page_label.position = Vector2(105, 20)
	add_child(page_label)
	show_page()


func make_nav_button(label: String, pos: Vector2, step: int) -> void:
	var b := Button.new()
	b.text = label
	b.position = pos
	b.pressed.connect(change_page.bind(step))
	add_child(b)


func change_page(step: int) -> void:
	var last_page := ceili(players.size() / float(PER_PAGE)) - 1
	page = clampi(page + step, 0, last_page)
	show_page()


func show_page() -> void:
	for c in grid.get_children():
		c.queue_free()
	var start := page * PER_PAGE
	for p in players.slice(start, start + PER_PAGE):
		var card := make_card(p)
		grid.add_child(card)
		if p["name"] == selected_player.get("name", ""):
			selected_card = card
			set_highlight(card, true)
	page_label.text = "Page %d" % (page + 1)


func make_card(p: Dictionary) -> Button:
	var card := Button.new()
	card.custom_minimum_size = Vector2(270, 200)
	card.alignment = HORIZONTAL_ALIGNMENT_LEFT
	card.text = short_text(p)
	card.gui_input.connect(on_card_input.bind(card, p))
	return card


func on_card_input(event: InputEvent, card: Button, p: Dictionary) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			select(card, p)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			flip(card, p)


func select(card: Button, p: Dictionary) -> void:
	if card == selected_card:
		set_highlight(card, false)
		selected_card = null
		selected_player = {}
		return
		
	if is_instance_valid(selected_card):
		set_highlight(selected_card, false)
	selected_card = card
	selected_player = p
	set_highlight(card, true)


func set_highlight(card: Button, on: bool) -> void:
	for state in ["normal", "hover", "pressed", "focus"]:
		if on:
			var box: StyleBoxFlat = card.get_theme_stylebox(state).duplicate()
			box.set_border_width_all(4)
			box.border_color = Color.GOLD
			card.add_theme_stylebox_override(state, box)
		else:
			card.remove_theme_stylebox_override(state)


func flip(card: Button, p: Dictionary) -> void:
	var was_short: bool = card.text == short_text(p)
	card.pivot_offset = card.size / 2
	var tween := card.create_tween()
	tween.tween_property(card, "scale:x", 0.0, 0.15)
	tween.tween_callback(func(): card.text = full_text(p) if was_short else short_text(p))
	tween.tween_property(card, "scale:x", 1.0, 0.15)


func short_text(p: Dictionary) -> String:
	return "%s  #%d\n%s\nOVERALL: %d" % [p["name"], p["number"], p["position"].capitalize(), p["overall"]]


func full_text(p: Dictionary) -> String:
	var t := short_text(p) + "\n\n"
	t += "Grade %d | Age %d | Hand %s\n" % [p["grade"], p["age"], p["hand"]]
	t += "Height %d in | Weight %d lb\n" % [p["height"], p["weight"]]
	t += "Wingspan %d in | Reach %d in\n\n" % [p["wingspan"], p["reach"]]
	for s in SKILLS:
		t += "%s: %d\n" % [s.capitalize(), p[s]]
	return t
