class_name Chunk extends Node

var st = SurfaceTool.new()
var size = 16
var blocks = []
var hp = 1

func hurt(at, n = 1):
	hp -= n
	if hp <= 0:
		blocks.erase(at)

func dig(at):
	if blocks.has(at):
		blocks.hurt(at)

func place(at):
	if valid(at):
		blocks.append(at)

func fill():
	for x in size:
		for y in size:
			for z in size:
				var at = Vector3(x, y, z)
				blocks.append(at)

func valid(at):
	return (at.x >= 0 and at.y >= 0 and at.z >= 0 and at.x < size and at.y < size and at.z < size)

func face(at, d):
	var p = at * 0.5
	st.set_normal(d)
	var verts = directions(d)
	for i in [0, 1, 2, 0, 2, 3]:
		st.add_vertex(p + verts[i])

func directions(d):
	match d:
		Vector3.UP:
			return [Vector3(0, 1, 0), Vector3(1, 1, 0), Vector3(1, 1, 1), Vector3(0, 1, 1)]
		Vector3.DOWN:
			return [Vector3(0, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 1), Vector3(1, 0, 0)]
		Vector3.LEFT:
			return [Vector3(0, 0, 0), Vector3(0, 1, 0), Vector3(0, 1, 1), Vector3(0, 0, 1)]
		Vector3.RIGHT:
			return [Vector3(1, 0, 0), Vector3(1, 0, 1), Vector3(1, 1, 1), Vector3(1, 1, 0)]
		Vector3.FORWARD:
			return [Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(1, 1, 0), Vector3(0, 1, 0)]
		Vector3.BACK:
			return [Vector3(0, 0, 1), Vector3(0, 1, 1), Vector3(1, 1, 1), Vector3(1, 0, 1)]

func block(at):
	for d in [Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]:
		var n = at + d
		if not valid(n) or (valid(n) and not blocks.has(n)):
			face(at, d)

func build():
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for b in blocks:
		block(b)
	st.index()
	return st.commit()
