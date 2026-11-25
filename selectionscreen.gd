extends Node2D


const KEY_STATS := {
	"setter":   ["setting", "passing", "serving"],
	"hitter":   ["attacking", "blocking", "serving"],
	"defender": ["defense", "passing", "serving"],
	"libero":   ["defense", "passing", "setting"],
}
	
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
