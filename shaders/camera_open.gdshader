shader_type canvas_item;

uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.4;
uniform float glitch_amount : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Basic noise for the glitch
float noise(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Glitch: Displace UVs based on noise and glitch_amount
    if (glitch_amount > 0.0) {
        uv.x += (noise(vec2(TIME, uv.y)) - 0.5) * 0.1 * glitch_amount;
    }

    vec4 color = texture(SCREEN_TEXTURE, uv);
    
    // Add white static noise during the glitch
    if (glitch_amount > 0.1) {
        float n = noise(uv + vec2(TIME));
        color.rgb = mix(color.rgb, vec3(n), glitch_amount * 0.5);
    }

    // Power-on Vignette (the "circular" opening look)
    float d = distance(uv, vec2(0.5));
    color.rgb *= smoothstep(0.8, vignette_intensity * 0.5, d);
    
    COLOR = color;
}
