extends Node

var over = false

func _ready():
	start()

func start():
	$Dungeon.generate()
