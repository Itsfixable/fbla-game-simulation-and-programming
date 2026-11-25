extends Node

#temp data(ts is fake)
var season := 1
var week := 1
var budget := 12500
var roster := []
var training_week := ["rest", "rest", "rest", "rest", "rest", "rest", "rest"]
var playerList := [
	make_player("Emma Johnson",    17, 12, 72, 150, 73, 108,  7, "R", "hitter",   88, 62, 74, 66, 40, 82),
	make_player("Sophia Martinez", 16, 11, 67, 138, 68,  99,  2, "R", "setter",   52, 64, 70, 78, 91, 45),
	make_player("Olivia Brooks",   18, 12, 66, 130, 66,  94,  1, "R", "libero",   30, 94, 60, 92, 55, 20),
	make_player("Ava Thompson",    15, 10, 70, 145, 71, 104, 11, "L", "hitter",   82, 58, 68, 60, 38, 78),
	make_player("Isabella Rivera", 17, 12, 68, 140, 69, 100,  5, "R", "defender", 55, 86, 72, 84, 48, 50),
	make_player("Mia Carter",      16, 11, 73, 158, 75, 110, 14, "R", "hitter",   85, 55, 65, 58, 35, 90),
	make_player("Harper Nguyen",   14,  9, 65, 125, 65,  92,  3, "R", "libero",   28, 88, 58, 86, 50, 18),
	make_player("Abigail Foster",  18, 12, 69, 142, 70, 103,  9, "L", "setter",   58, 66, 76, 74, 89, 52),
	make_player("Emily Sanders",   17, 12, 71, 148, 72, 106, 10, "R", "hitter",   84, 60, 70, 62, 42, 80),
	make_player("Madison Reed",    16, 11, 67, 136, 67,  97,  6, "R", "defender", 50, 84, 66, 82, 46, 44),
	make_player("Chloe Bennett",   15, 10, 72, 152, 74, 107, 12, "R", "hitter",   79, 54, 62, 56, 34, 85),
	make_player("Grace Patel",     17, 12, 66, 132, 66,  95,  4, "R", "setter",   48, 62, 68, 72, 87, 40),
	make_player("Lily Hughes",     14,  9, 68, 134, 68,  98, 15, "L", "defender", 52, 80, 64, 78, 44, 46),
	make_player("Hannah Kim",      16, 11, 70, 144, 71, 103,  8, "R", "hitter",   80, 59, 72, 61, 39, 79),
	make_player("Natalie Cruz",    18, 12, 64, 124, 64,  90, 17, "R", "libero",   25, 91, 55, 90, 48, 15),
	make_player("Ella Murphy",     15, 10, 69, 138, 70, 101, 13, "R", "defender", 56, 82, 70, 80, 45, 52),
	make_player("Jake Williams",   17, 12, 76, 185, 78, 125,  7, "R", "hitter",   90, 60, 78, 62, 38, 86),
	make_player("Ethan Davis",     16, 11, 72, 168, 74, 117,  2, "R", "setter",   55, 68, 72, 76, 92, 50),
	make_player("Lucas Garcia",    18, 12, 69, 155, 70, 108,  1, "R", "libero",   32, 95, 62, 93, 52, 22),
	make_player("Mason Clark",     17, 12, 78, 195, 80, 129, 11, "L", "hitter",   92, 56, 74, 58, 35, 91),
	make_player("Logan Hayes",     16, 11, 73, 172, 74, 118,  5, "R", "defender", 58, 87, 70, 85, 46, 54),
	make_player("Noah Rodriguez",  15, 10, 74, 170, 76, 119, 14, "R", "hitter",   80, 55, 66, 57, 36, 82),
	make_player("Carter Evans",    18, 12, 71, 165, 72, 114,  9, "R", "setter",   54, 70, 74, 77, 90, 48),
	make_player("Owen Mitchell",   14,  9, 66, 135, 67,  96,  3, "R", "libero",   27, 85, 55, 84, 47, 19),
	make_player("Ryan Cooper",     17, 12, 77, 190, 79, 127, 10, "R", "hitter",   89, 61, 80, 63, 40, 88),
	make_player("Dylan Parker",    16, 11, 72, 166, 73, 116,  6, "L", "defender", 57, 83, 68, 81, 44, 52),
	make_player("Caleb Turner",    15, 10, 75, 175, 77, 121, 12, "R", "hitter",   81, 54, 64, 56, 34, 84),
	make_player("Tyler Morgan",    17, 12, 70, 160, 71, 111,  4, "R", "setter",   50, 64, 70, 73, 86, 44),
	make_player("Nathan Brooks",   16, 11, 74, 178, 75, 120, 15, "R", "hitter",   83, 58, 69, 60, 37, 83),
	make_player("Aiden Scott",     15, 10, 70, 158, 71, 110,  8, "R", "defender", 53, 81, 66, 79, 43, 48),
	make_player("Jordan Lee",      18, 12, 68, 150, 69, 105, 17, "R", "libero",   30, 92, 60, 91, 50, 20),
	make_player("Avery Collins",   14,  9, 71, 156, 72, 112, 13, "R", "defender", 55, 80, 65, 77, 45, 50),
]

func make_player(name: String, age: int, grade: int, height: int, weight: int,
		wingspan: int, reach: int, number: int, hand: String, position: String,
		attacking: int, defense: int, serving: int, passing: int,
		setting: int, blocking: int) -> Dictionary:
	var overall := roundi((attacking + defense + serving + passing + setting + blocking) / 6.0)
	return {
		"name": name, "age": age, "grade": grade,
		"height": height, "weight": weight, "wingspan": wingspan, "reach": reach,
		"number": number, "hand": hand, "position": position,
		"attacking": attacking, "defense": defense, "serving": serving,
		"passing": passing, "setting": setting, "blocking": blocking,
		"overall": overall,
	}
