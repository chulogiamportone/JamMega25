shader_type canvas_item;

uniform float glow_strength : hint_range(0.0, 3.0) = 1.5;
uniform float glow_size : hint_range(0.0, 5.0) = 2.0;
uniform vec4 glow_color = vec4(1.0, 1.0, 0.8, 1.0);
uniform bool use_sprite_color = true;

void fragment() {
    vec2 uv = UV;
    vec4 sprite_color = texture(TEXTURE, uv);

    // Crear glow con menos samples para mejor rendimiento
    vec4 glow = vec4(0.0);
    vec2 pixel_size = TEXTURE_PIXEL_SIZE * glow_size;

    // 8 direcciones principales
    vec2 directions[8];
    directions[0] = vec2(1.0, 0.0);
    directions[1] = vec2(-1.0, 0.0);
    directions[2] = vec2(0.0, 1.0);
    directions[3] = vec2(0.0, -1.0);
    directions[4] = vec2(0.707, 0.707);
    directions[5] = vec2(-0.707, 0.707);
    directions[6] = vec2(0.707, -0.707);
    directions[7] = vec2(-0.707, -0.707);

    for(int i = 0; i < 8; i++) {
        glow += texture(TEXTURE, uv + directions[i] * pixel_size);
        glow += texture(TEXTURE, uv + directions[i] * pixel_size * 0.5);
    }

    glow /= 16.0;
    glow *= glow_strength;

    if (use_sprite_color) {
        glow.rgb *= sprite_color.rgb;
    } else {
        glow.rgb *= glow_color.rgb;
    }

    vec4 final_color = sprite_color;
    final_color.rgb += glow.rgb * glow.a;

    COLOR = final_color;
}