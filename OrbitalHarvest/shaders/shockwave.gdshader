shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 global_position = vec2(800,500.0);
uniform float force = 1.0;
uniform float size = 0.0;
uniform float thickness = 0.01;

void fragment(){
	vec2 i_resolution = 1.0 / SCREEN_PIXEL_SIZE ;
	vec2 center = global_position;
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	center.x = center.x / i_resolution.x;
	center.x = (center.x - 0.5) / ratio + 0.5;
	center.y = center.y / i_resolution.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0) ) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size-0.1, size, length(scaledUV - center))) * smoothstep(size-thickness-0.1, size-thickness, length(scaledUV - center));
	vec2 disp = normalize(SCREEN_UV - center) * force * mask;
	//COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV - disp, 0);
	//COLOR.rgb = vec3(mask);
}