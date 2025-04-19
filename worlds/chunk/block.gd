class_name Block

const STONE = 0
const BRICK = 1
const OBSIDIAN = 2

var t
var l
var hp

func _init(type):
	t = type
	match t:
		STONE: hp = 1
		BRICK: hp = 3
		OBSIDIAN: hp = INF
	l = hp

func hurt():
	l -= 1
	return l <= 0
