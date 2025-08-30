shader_type canvas_item;


uniform float absorption_radius : hint_range(0.0, 1.0) = 0.3;
uniform vec2 absorption_center  = vec2(0.5, 0.5);
uniform float absorption_strength : hint_range(0.0, 2.0) = 1.0;
uniform float water_distortion : hint_range(0.0, 0.1) = 0.02;
uniform float time_speed : hint_range(0.0, 5.0) = 1.0;
uniform sampler2D noise_texture;

varying vec2 world_position;

void vertex() {
	world_position = VERTEX;
}

void fragment() {
	vec2 uv = UV;
	vec4 original_color = texture(TEXTURE, uv);
	
	// Calcular distancia desde el centro de absorción
	float distance_to_center = distance(uv, absorption_center);
	
	// Crear máscara de absorción
	float absorption_mask = 1.0 - smoothstep(0.0, absorption_radius, distance_to_center);
	
	// Efecto de ondas de agua
	vec2 noise_uv = uv + TIME * time_speed * 0.1;
	float noise = texture(noise_texture, noise_uv).r;
	
	// Distorsión tipo agua
	vec2 water_offset = vec2(
		sin(uv.y * 20.0 + TIME * time_speed) * water_distortion,
		cos(uv.x * 15.0 + TIME * time_speed) * water_distortion
	) * absorption_mask;
	
	// Aplicar distorsión
	vec2 distorted_uv = uv + water_offset * absorption_strength;
	vec4 distorted_color = texture(TEXTURE, distorted_uv);
	
	// Efecto de disolución/reconstrucción
	float dissolve_factor = absorption_mask * (noise + 0.5);
	dissolve_factor = smoothstep(0.3, 0.7, dissolve_factor);
	
	// Mezclar colores
	vec4 final_color = mix(original_color, distorted_color, absorption_mask);
	final_color.a *= (1.0 - dissolve_factor * 0.5);
	
	// Efecto de brillo acuático
	float water_shine = sin(TIME * time_speed * 2.0 + distance_to_center * 10.0) * 0.1 + 0.9;
	final_color.rgb *= water_shine * (1.0 + absorption_mask * 0.2);
	
	COLOR = final_color;
}