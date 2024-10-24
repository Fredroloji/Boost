RSRC                    Shader            ��������                                                  resource_local_to_scene    resource_name    code    script           local://Shader_k7e1x �          Shader          �  shader_type spatial;

uniform float wave_height = 0.2;
uniform float r_speed = 0.0;
uniform float g_speed = 0.0;
uniform float b_speed = 0.0;

void vertex() {
	VERTEX.y += sin(TIME * 5.0 + VERTEX.x * 10.0) * wave_height;
}

void fragment() {
	vec3 colour;
	colour.r = (sin(TIME * r_speed + VERTEX.x * 10.0 * 0.2) + 1.0) * 0.5; 
	colour.g = (sin(TIME * g_speed + VERTEX.x * 10.0 * 0.2) + 1.0) * 0.5; 
	colour.b = (sin(TIME * b_speed + VERTEX.x * 10.0 * 0.2) + 1.0) * 0.5;
	ALBEDO = colour;
}
       RSRC