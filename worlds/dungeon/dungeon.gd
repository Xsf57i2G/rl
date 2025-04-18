class_name Dungeon extends Node3D

@export var p = 1
@export var c = 1
@export var h = 5
@export var layers = 1
@export var k = Chunk.new()
@export var bsp = BSP.new()
@export var r = Ruin.new()

func generate():
	bsp.build(AABB(Vector3.ZERO, Vector3(k.w, k.w, k.w)), bsp.depth)
	for l in bsp.leaves():
		if l.bounds.position.y < layers and randf() < c:
			room(l)
	r.dig(k)
	$Navigation/Skin.mesh = k.form()
	$Collision.shape = k.collider()
	$Navigation.navigation_mesh = k.navmesh()

func room(l):
	var bnd = l.bounds
	var p1 = bnd.position + Vector3.ONE * p
	var sz = (bnd.size - Vector3.ONE * p * 2).max(Vector3.ZERO)
	sz.y = min(sz.y, h)
	var a = AABB(p1, sz)
	k.dig(a)
	var a1 = a.position.floor()
	var b1 = (a.position + a.size).ceil()
	for x in range(int(a1.x), int(b1.x)):
		for y in range(int(a1.y), int(b1.y)):
			for z in range(int(a1.z), int(b1.z)):
				k.place(Vector3(x, y, z), Block.BRICK)

func spawn(w):
	var keys = k.b.keys()
	if keys.size() > 0:
		w.position = keys.pick_random()
