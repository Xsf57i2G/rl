use avian3d::prelude::*;
use bevy::prelude::*;
use bevy::render::mesh::{Indices, PrimitiveTopology};

pub fn setup(
	mut commands: Commands,
	mut meshes: ResMut<Assets<Mesh>>,
	mut materials: ResMut<Assets<StandardMaterial>>,
) {
	commands.spawn((
		ColliderConstructor::TrimeshFromMesh,
		Mesh3d(meshes.add(generate(16))),
		MeshMaterial3d(materials.add(StandardMaterial::default())),
		RigidBody::Static,
	));
}

fn generate(n: usize) -> Mesh {
	const SIZE: f32 = 64.0;

	let mut vertices = Vec::new();
	let mut indices = Vec::new();
	let mut uvs = Vec::new();

	for z in 0..=n {
		for x in 0..=n {
			let east = (x as f32 / n as f32) * SIZE;
			let north = (z as f32 / n as f32) * SIZE;

			vertices.push([east, 0.0, north]);
			uvs.push([x as f32 / n as f32, z as f32 / n as f32]);
		}
	}

	for z in 0..n {
		for x in 0..n {
			let i = z * (n + 1) + x;
			indices.push(i as u32);
			indices.push((i + n + 1) as u32);
			indices.push((i + 1) as u32);
			indices.push((i + 1) as u32);
			indices.push((i + n + 1) as u32);
			indices.push((i + n + 2) as u32);
		}
	}

	let mut mesh = Mesh::new(PrimitiveTopology::TriangleList, default());

	mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION, vertices);
	mesh.insert_indices(Indices::U32(indices));
	mesh.insert_attribute(Mesh::ATTRIBUTE_UV_0, uvs);
	mesh.compute_normals();
	mesh.generate_tangents().unwrap();

	mesh
}
