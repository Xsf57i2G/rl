class_name Chunk

enum Type {STONE, BRICK}

var st = SurfaceTool.new()
var w = 32
var world = {}
var stats = {
	Type.STONE: {
		life = 1,
		color = Color.LIGHT_CORAL
	},
	Type.BRICK: {
		life = 2,
		color = Color.CORNFLOWER_BLUE
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

func dig(area, wall_type = null):
	var a = area.position.floor()
	var b = (area.position + area.size).ceil()
	var area_int = AABB(a, b - a)
	var blocks_to_wall = {}
	var blocks_to_erase = []
	for x in range(int(a.x), int(b.x)):
		for y in range(int(a.y), int(b.y)):
			for z in range(int(a.z), int(b.z)):
				var spot = Vector3(x, y, z)
				if world.has(spot):
					blocks_to_erase.append(spot)
					if wall_type != null:
						for way in [Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]:
							var next_spot = spot + way
							if inside(next_spot) and world.has(next_spot) and not area_int.has_point(next_spot):
								if not area_int.has_point(next_spot):
									blocks_to_wall[next_spot] = wall_type
	for spot in blocks_to_erase:
		world.erase(spot)
	for spot in blocks_to_wall:
		if not spot in blocks_to_erase:
			place(spot, blocks_to_wall[spot])

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
	var block = world[spot]
	var c = stats[block.type].color
	st.set_color(c)
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
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for block in world.keys():
		cube(block)
	st.index()
	return st.commit()

func navmesh():
	var st2 = SurfaceTool.new()
	st2.begin(Mesh.PRIMITIVE_TRIANGLES)
	for block in world.keys():
		var next = block + Vector3.UP
		if not inside(next) or not world.has(next):
			st2.set_normal(Vector3.UP)
			var points = map(Vector3.UP)
			for i in [0, 1, 2, 0, 2, 3]:
				st2.add_vertex(Vector3(block.x, block.y, block.z) + points[i])
	st2.index()
	var mesh = st2.commit()
	var n = NavigationMesh.new()
	n.create_from_mesh(mesh)
	return n

func collider(m):
	var c = ConcavePolygonShape3D.new()
	c.set_faces(m.get_faces())
	return c
