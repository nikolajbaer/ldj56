shader_type spatial;

uniform vec4 shallow_color : source_color = vec4(0.1, 0.4, 0.7, 1.0);
uniform vec4 deep_color : source_color = vec4(0.0, 0.2, 0.5, 1.0);
uniform float wave_speed = 0.5;
uniform float wave_frequency = 10.0;
uniform float wave_amplitude = 0.1;
uniform float foam_amount = 0.1;
uniform float foam_cutoff = 0.8;
uniform sampler2D noise_texture : source_color, filter_linear_mipmap, repeat_enable;

varying vec3 world_position;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // Add some vertical displacement for waves
    float wave = sin(world_position.x * wave_frequency + TIME * wave_speed) *
                 cos(world_position.z * wave_frequency + TIME * wave_speed) *
                 wave_amplitude;
    VERTEX.y += wave;
}

void fragment() {
    // Calculate wave pattern
    vec2 uv = world_position.xz / 10.0;
    float noise = texture(noise_texture, uv + TIME * 0.05).r;

    // Mix shallow and deep colors based on world position height
    float depth = smoothstep(-1.0, 1.0, world_position.y);
    vec3 water_color = mix(deep_color.rgb, shallow_color.rgb, depth);

    // Add foam
    float foam = smoothstep(foam_cutoff, foam_cutoff + foam_amount, noise);
    water_color = mix(water_color, vec3(1.0), foam);

    // Apply final color
    ALBEDO = water_color;

    // Add some specularity and smoothness
    METALLIC = 0.1;
    SPECULAR = 0.6;
    ROUGHNESS = 0.2;
}