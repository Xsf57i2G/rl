shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float speed = 1.5;
uniform float strength = 0.3;
uniform float scale = 1.0;
uniform vec3 base_color = vec3(1.0, 0.5, 0.0);
uniform vec3 tip_color = vec3(1.0, 1.0, 0.0);
uniform float emission_power = 15.0;
uniform float fade_start = 0.1;
uniform float fade_end = 0.9;
uniform sampler2D noise_tex : hint_default_white;
uniform float noise_strength = 0.05;
uniform float noise_scale = 4.0;
uniform float noise_scroll_speed = 0.8;
uniform float flicker_speed_mult = 1.5;
uniform float flicker_strength = 0.5;

void vertex() {
	float t = TIME * speed;
	float wave = (sin(VERTEX.x * scale + t) + cos(VERTEX.z * scale + t * 1.3)) * strength;
	float wave_influence = smoothstep(0.0, 0.5, VERTEX.y);
	VERTEX.y += wave * wave_influence;
	float noise_time = TIME * noise_scroll_speed;
	vec2 noise_uv_x = vec2(VERTEX.x, VERTEX.y) * noise_scale + vec2(noise_time, 0.0);
	vec2 noise_uv_z = vec2(VERTEX.z, VERTEX.y) * noise_scale + vec2(0.0, noise_time * 1.2);
	float noise_x = (texture(noise_tex, noise_uv_x).r * 2.0 - 1.0);
	float noise_z = (texture(noise_tex, noise_uv_z).r * 2.0 - 1.0);
	float noise_influence = smoothstep(0.1, 0.7, VERTEX.y);
	VERTEX.x += noise_x * noise_strength * noise_influence;
	VERTEX.z += noise_z * noise_strength * noise_influence;
}

void fragment() {
	float h = clamp(VERTEX.y, 0.0, 1.0);
	vec3 col = mix(base_color, tip_color, smoothstep(0.0, 0.8, h));
	float flicker_noise_val = texture(noise_tex, vec2(TIME * noise_scroll_speed * flicker_speed_mult, 0.5)).r;
	float flicker_effect = 1.0 - flicker_strength * flicker_noise_val;
	ALBEDO = col;
	EMISSION = col * emission_power * flicker_effect;
	float alpha_base = smoothstep(0.0, fade_start, h);
	float alpha_tip = 1.0 - smoothstep(fade_end, 1.0, h);
	ALPHA = alpha_base * alpha_tip * (1.0 - (flicker_noise_val * 0.2));
}