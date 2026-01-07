shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

group_uniforms Timing_Settings;
uniform float pulse_speed : hint_range(0.1, 5.0) = 0.5; // How fast it switches between waving and stopping
uniform float glitch_duration : hint_range(0.1, 1.0) = 0.5; // Higher = waves stay longer

group_uniforms Wavy_Settings;
uniform float wave_count : hint_range(1.0, 50.0) = 20.0;
uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.006;
uniform float wave_speed : hint_range(0.0, 10.0) = 4.0;

group_uniforms Glitch_Settings;
uniform float range : hint_range(0.0, 0.5) = 0.05;
uniform float offsetIntensity : hint_range(0.0, 0.1) = 0.02;

group_uniforms Static_Settings;
uniform float noiseQuality : hint_range(1.0, 500.0) = 250.0;
uniform float noiseIntensity : hint_range(0.0, 0.2) = 0.02;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float verticalBar(float pos, float uvY, float offset) {
    float edge0 = (pos - range);
    float edge1 = (pos + range);
    float x = smoothstep(edge0, pos, uvY) * offset;
    x -= smoothstep(pos, edge1, uvY) * offset;
    return x;
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // 1. THE PULSE (The "Wave then Stop" engine)
    // We create a value that smoothly goes 0 -> 1 -> 0
    float pulse = sin(TIME * pulse_speed);
    // Use smoothstep to sharpen the "on/off" moments so it stays quiet longer
    float wave_trigger = smoothstep(1.0 - glitch_duration, 1.0, pulse);

    // 2. ANALOG WAVY LINES (Multiplied by pulse)
    float wave = sin(uv.y * wave_count + (TIME * wave_speed)) * wave_amplitude * wave_trigger;
    uv.x += wave;
    
    // 3. ORIGINAL GLITCH LINES (Restored loop logic)
    // These now only move when the wave pulse is active
    for (float i = 0.0; i < 0.75; i += 0.09) {
        float d = mod(TIME * (i * 0.4), 1.7);
        float o = sin(1.0 - tan(TIME * 0.2 * i)) * offsetIntensity * wave_trigger;
        uv.x += verticalBar(d, uv.y, o);
    }
    
    // 4. BACKGROUND STATIC (Always constant for FNAF atmosphere)
    float uvY = floor(uv.y * noiseQuality) / noiseQuality;
    float static_grain = rand(vec2(uvY, TIME * 15.0));
    
    // 5. SAMPLING
    float r = textureLod(SCREEN_TEXTURE, uv + vec2(wave, 0.0), 0.0).r;
    float g = textureLod(SCREEN_TEXTURE, uv, 0.0).g;
    float b = textureLod(SCREEN_TEXTURE, uv - vec2(wave, 0.0), 0.0).b;
    
    vec3 screen_color = vec3(r, g, b);
    vec3 final_color = mix(screen_color, vec3(static_grain), noiseIntensity);
    
    COLOR = vec4(final_color, 1.0);
}
