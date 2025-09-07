use bevy::{
	input::mouse::{AccumulatedMouseMotion, AccumulatedMouseScroll},
	prelude::*,
	window::CursorGrabMode,
};

#[derive(Component)]
pub struct Pivot {
	pub distance: f32,
	pub pitch: f32,
	pub target: Vec3,
	pub yaw: f32,
}

pub fn setup(mut commands: Commands, mut windows: Single<&mut Window>) {
	windows.cursor_options.grab_mode = CursorGrabMode::Confined;
	commands.spawn((
		Pivot {
			distance: 10.0,
			pitch: 0.0,
			target: Vec3::Y,
			yaw: 0.0,
		},
		Camera::default(),
		Camera3d::default(),
	));
}

pub fn orbit(
	mut eyes: Query<(&mut Pivot, &mut Transform), With<Camera3d>>,
	motion: Res<AccumulatedMouseMotion>,
) {
	for (mut pivot, mut transform) in &mut eyes {
		pivot.yaw -= motion.delta.x * 0.001;
		pivot.pitch = (pivot.pitch - motion.delta.y * 0.001).clamp(-1.5, 1.5);
		let rotation = Quat::from_rotation_y(pivot.yaw) * Quat::from_rotation_x(pivot.pitch);
		transform.translation = pivot.target + rotation * Vec3::Z * pivot.distance;
		transform.look_at(pivot.target, Vec3::Y);
	}
}

pub fn zoom(mut eye: Query<&mut Pivot>, scroll: Res<AccumulatedMouseScroll>) {
	for mut e in eye.iter_mut() {
		e.distance -= scroll.delta.y;
		e.distance = e.distance.clamp(1.0, 50.0);
	}
}
