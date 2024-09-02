shader_type spatial;
render_mode unshaded, blend_mul;

uniform float wave_height = 0.2;
uniform float r_speed = 0.0;
uniform float g_speed = 0.0;
uniform float b_speed = 0.0;

void vertex() {
	VERTEX.y += sin(TIME * 5.0 + VERTEX.x * 10.0) * wave_height;
}

void fragment() {
	vec3 colour;
	colour.r = (sin(TIME));
	colour.g = (sin(TIME * 0.0 + VERTEX.x * 0.0 * 0.2) + 1.0) * 0.5; 
	colour.b = (sin(TIME * 0.0 + VERTEX.x * 0.0 * 0.2) + 1.0) * 0.5;
	ALBEDO = colour;
}