use avian3d::prelude::*;
use bevy::prelude::*;

mod eye;
mod terrain;

fn main() {
	App::new()
		.add_plugins((
			DefaultPlugins,
			PhysicsPlugins::default(),
			PhysicsDebugPlugin::default(),
		))
		.add_systems(Startup, (eye::setup, terrain::setup))
		.add_systems(Update, (eye::orbit, eye::zoom))
		.run();
}
