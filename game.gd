extends Node

var over = false

func _ready():
	$Dungeon.generate()
	$Dungeon.spawn(preload("uid://bhsrmm4akehyf"))
