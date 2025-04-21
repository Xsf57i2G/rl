class_name Item extends Resource

@export_range(1, 100, 1) var damage
@export var durability = 1
@export var hp = 1
@export var weight = 1
@export var speed = 1
var curses = []

func generate():
	pass

func equip():
	if curses:
		for c in curses:
			c.apply(self)
