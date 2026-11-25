# trainscreen.gd: attach to the root Control. The script builds the whole screen,
# so the scene itself stays empty in the editor.
extends Control

# How each activity changes team energy (later: move these into your tuning file)
const ACTIVITIES := {
	"weights": {"label": "WEIGHTS", "short": "WGHT", "energy": -20},
	"cardio":  {"label": "CARDIO",  "short": "CRDO", "energy": -15},
	"drills":  {"label": "DRILLS",  "short": "DRLL", "energy": -15},
	"rest":    {"label": "REST",    "short": "REST", "energy": 30},
}
const ORDER := ["weights", "cardio", "drills", "rest"]
const DAY_NAMES := ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
const RISK_LINE := 30          # energy below this = injury warning

# Layout knobs: change these instead of dragging things
const CARD_W := 96             # width of each day card AND its energy bar
const GAP := 8                 # space between day cards
const HOME_SCENE := "res://homescreen/homescreen.tscn"

var draft: Array = []          # the plan being edited (not real until Confirm)
var selected := "drills"       # which activity a click will place
var day_buttons: Array[Button] = []
var energy_bars: Array[ProgressBar] = []
var warning_label: Label
var summary_label: Label


func _ready() -> void:

	set_anchors_preset(Control.PRESET_FULL_RECT)
	draft = GameState.training_week.duplicate()    # start from last week's plan
	_build_ui()
	refresh()


# ---------------------------------------------------------------- building the screen
func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 32)
	add_child(margin)

	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 16)
	margin.add_child(column)

	# Header: title on the left, money on the right
	var header := HBoxContainer.new()
	column.add_child(header)
	var title := Label.new()
	title.text = "TRAINING - SEASON %d, WEEK %d" % [GameState.season, GameState.week]
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	var money := Label.new()
	money.text = "$%d" % GameState.budget
	header.add_child(money)

	# 7 day cards with an energy bar under each one
	var day_row := _centered_row(column, GAP)
	var bar_row := _centered_row(column, GAP)
	for i in 7:
		var day := Button.new()
		day.custom_minimum_size = Vector2(CARD_W, 64)
		day.pressed.connect(_on_day_pressed.bind(i))
		day_row.add_child(day)
		day_buttons.append(day)

		var bar := ProgressBar.new()
		bar.custom_minimum_size = Vector2(CARD_W, 48)
		bar.fill_mode = ProgressBar.FILL_BOTTOM_TO_TOP
		bar.show_percentage = false
		bar_row.add_child(bar)
		energy_bars.append(bar)

	warning_label = _centered_label(column)
	summary_label = _centered_label(column)

	# Activity picker: only one can be selected at a time (ButtonGroup)
	var picker := _centered_row(column, 12)
	var group := ButtonGroup.new()
	for key in ORDER:
		var b := Button.new()
		b.text = ACTIVITIES[key].label
		b.toggle_mode = true
		b.button_group = group
		b.custom_minimum_size = Vector2(140, 48)
		b.button_pressed = (key == selected)
		b.pressed.connect(func(): selected = key)
		picker.add_child(b)

	# Bottom row: Back on the left, Confirm pushed to the right by a spacer
	var bottom := HBoxContainer.new()
	column.add_child(bottom)
	var back := Button.new()
	back.text = "< BACK"
	back.custom_minimum_size = Vector2(120, 48)
	back.pressed.connect(_go_home)
	bottom.add_child(back)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom.add_child(spacer)
	var confirm := Button.new()
	confirm.text = "CONFIRM >"
	confirm.custom_minimum_size = Vector2(160, 48)
	confirm.pressed.connect(_on_confirm)
	bottom.add_child(confirm)


func _centered_row(parent: Node, gap: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", gap)
	parent.add_child(row)
	return row


func _centered_label(parent: Node) -> Label:
	var label := Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(label)
	return label


# ---------------------------------------------------------------- reacting to clicks
func _on_day_pressed(i: int) -> void:
	draft[i] = selected
	refresh()


## Redraws everything from the draft so the screen always matches the plan.
func refresh() -> void:
	var energy := 100
	var risky_day := -1
	var counts := {"weights": 0, "cardio": 0, "drills": 0, "rest": 0}

	for i in 7:
		var activity: String = draft[i]
		counts[activity] += 1
		day_buttons[i].text = "%s\n%s" % [DAY_NAMES[i], ACTIVITIES[activity].short]

		energy = clampi(energy + ACTIVITIES[activity].energy, 0, 100)
		energy_bars[i].value = energy
		if energy < RISK_LINE and risky_day == -1:
			risky_day = i

	if risky_day >= 0:
		warning_label.text = "! %s: HIGH INJURY RISK - ADD A REST DAY" % DAY_NAMES[risky_day]
	else:
		warning_label.text = ""

	summary_label.text = "Weights x%d   Cardio x%d   Drills x%d   Rest x%d" % [
		counts.weights, counts.cardio, counts.drills, counts.rest]


func _on_confirm() -> void:
	GameState.training_week = draft.duplicate()    # the plan becomes real here
	_go_home()


func _go_home() -> void:
	get_tree().change_scene_to_file(HOME_SCENE)
