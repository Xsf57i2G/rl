class_name Dungeon extends Node3D

@export var depth = 4
@export var pad = 1
@export var chance = 1
@export var h = 5

var bsp = BSP.new()
var chunk = Chunk.new()

func generate():
	bsp.build(AABB(Vector3.ZERO, Vector3(chunk.w, chunk.w, chunk.w)), depth)
	for l in bsp.leaves():
		if randf() < chance:
			room(l)
	$Navigation.navigation_mesh = chunk.navmesh()
	$Navigation/Skin.mesh = chunk.form()
	$Collision.shape = chunk.collider()

func room(leaf):
	var b = leaf.bounds
	var p = b.position + Vector3.ONE * pad
	var s = (b.size - Vector3.ONE * pad * 2).max(Vector3.ZERO)
	s.y = min(s.y, h)
	chunk.dig(AABB(p, s))

func spawn(what):
	what.position = chunk.blocks.pick_random()
