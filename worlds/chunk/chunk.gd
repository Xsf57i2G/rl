class_name Chunk

enum Type {STONE, BRICK}

var st = SurfaceTool.new()
var w = 32
var world = {}
var stats = {
	Type.STONE: {
		life = 1,
	},
	Type.BRICK: {
		life = 2,
	}
}

func hurt(spot, force = 1):
	if world.has(spot):
		if spot.x == 0 or spot.x == w-1 or spot.y == 0 or spot.y == w-1 or spot.z == 0 or spot.z == w-1:
			return
		var block = world[spot]
		block.life -= force
		if block.life <= 0:
			world.erase(spot)

func dig(area, f = Type.BRICK):
	var a = area.position.floor()
	var b = (area.position + area.size).ceil()
	for x in range(int(a.x), int(b.x)):
		if x < 0 or x >= w:
			continue
		for y in range(int(a.y), int(b.y)):
			if y < 0 or y >= w:
				continue
			for z in range(int(a.z), int(b.z)):
				if z < 0 or z >= w:
					continue
				if x == 0 or x == w-1 or y == 0 or y == w-1 or z == 0 or z == w-1:
					continue
				world.erase(Vector3(x, y, z))

func place(spot, f = Type.STONE):
	if inside(spot):
		world[spot] = {
			type = f,
			life = stats[f].life
		}

func fill():
	for x in w:
		for y in w:
			for z in w:
				var spot = Vector3(x, y, z)
				place(spot)

func inside(spot):
	return (spot.x >= 0 and spot.y >= 0 and spot.z >= 0 and spot.x < w and spot.y < w and spot.z < w)

func side(spot, way):
	st.set_normal(way)
	var points = map(way)
	for i in [0, 1, 2, 0, 2, 3]:
		st.add_vertex(Vector3(spot.x, spot.y, spot.z) + points[i])

func map(way):
	match way:
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

func cube(spot):
	for way in [Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]:
		var next = spot + way
		if not inside(next) or not world.has(next):
			side(spot, way)

func form():
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for block in world.keys():
		cube(block)
	st.index()
	return st.commit()
