extends Node

var over = false

func _ready():
	$Dungeon.generate()
	$Dungeon.spawn($Monster)
	$Dungeon.spawn($Prisoner)
