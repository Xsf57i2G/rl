class_name Chunk

var st = SurfaceTool.new()
var size = 8
var blocks = []
var hp = 1

func hurt(at, n = 1):
	hp -= n
	if hp <= 0:
		blocks.erase(at)

func dig(box):
	var a = box.position.floor()
	var b = (box.position + box.size).ceil()
	for x in range(int(a.x), int(b.x)):
		if x < 0 or x >= size:
			continue
		for y in range(int(a.y), int(b.y)):
			if y < 0 or y >= size:
				continue
			for z in range(int(a.z), int(b.z)):
				if z < 0 or z >= size:
					continue
				blocks.erase(Vector3(x, y, z))

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
	st.set_normal(d)
	var verts = directions(d)
	for i in [0, 1, 2, 0, 2, 3]:
		st.add_vertex(Vector3(at.x, at.y, at.z) + verts[i])

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
		if not valid(n) or not blocks.has(n):
			face(at, d)

func build():
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for b in blocks:
		block(b)
	st.index()
	return st.commit()
