shader_type canvas_item;

uniform bool is_cut = false;
uniform float cut_progress : hint_range(0.0, 1.0) = 0.0;
uniform float cut_softness : hint_range(0.0, 0.2) = 0.05;
uniform float water_flow_strength : hint_range(0.0, 0.1) = 0.03;
uniform sampler2D noise_texture;

void fragment() {
	vec2 uv = UV;
	vec4 base_color = texture(TEXTURE, uv);
	
	if (is_cut) {
		// Línea diagonal: esquina sup der → esquina inf izq
		float diagonal_line = uv.y + uv.x - 1.0;
		float line_distance = abs(diagonal_line);
		
		// UV distorsionada
		vec2 distorted_uv = uv;
		if (cut_progress > 0.0) {
			// Centro de la grieta
			vec2 line_center = vec2((1.0 - uv.y), uv.y);
			vec2 to_center = line_center - uv;
			float distortion_mask = 1.0 - smoothstep(0.0, cut_softness * 3.0, line_distance);
			
			// ⚡ Ruido con fallback: valores suaves si la textura no está lista
			vec2 noise_uv = clamp(uv * 3.0 + vec2(TIME * 0.5, 0.0), vec2(0.0), vec2(1.0));
			float flow_noise = texture(noise_texture, noise_uv).r;
			// Si todavía devuelve 0 (primer frame), lo ponemos a 1
			flow_noise = max(flow_noise, 1.0);
			flow_noise = smoothstep(0.3, 0.7, flow_noise);
			
			// Distorsión hacia la grieta
			vec2 flow_direction = normalize(to_center);
			float flow_intensity = cut_progress * distortion_mask * flow_noise;
			distorted_uv += flow_direction * water_flow_strength * flow_intensity;
			distorted_uv = clamp(distorted_uv, vec2(0.0), vec2(1.0));
		}
		
		vec4 distorted_color = texture(TEXTURE, distorted_uv);
		
		// Máscara de corte
		float cut_mask = step(cut_softness, line_distance);
		
		// ⚡ Bordes acuosos con fallback igual
		vec2 dissolve_uv = clamp(uv * 5.0 + vec2(TIME * 0.3, TIME * 0.3), vec2(0.0), vec2(1.0));
		float dissolve = texture(noise_texture, dissolve_uv).r;
		dissolve = max(dissolve, 1.0);
		dissolve = smoothstep(0.4, 0.6, dissolve);
		
		// Transparencia del corte
		float visibility = mix(cut_mask * dissolve, 1.0, cut_progress);
		
		base_color = mix(base_color, distorted_color, cut_progress * 0.8);
		base_color.a *= visibility;
		
		// Brillo acuático
		if (cut_progress > 0.0 && cut_progress < 1.0) {
			float water_shine = sin(TIME * 3.0 + line_distance * 10.0) * 0.1 + 0.9;
			base_color.rgb *= water_shine;
		}
	}
	
	COLOR = base_color;
}