shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform sampler2D screenTextureSampler : hint_screen_texture, filter_linear_mipmap;
uniform vec4 overlayColor : source_color = vec4(0.75, 0.65, 0.4, 1);
uniform vec2 size = vec2(2.5, 2.5);

void fragment() {
	vec4 noiseTexture = texture(noise, UV);
	vec4 screenTexture = texture(screenTextureSampler, SCREEN_UV);

	COLOR = (overlayColor + screenTexture) / 2.0;
	COLOR.a = noiseTexture.r; // - (abs(UV.x) / size.x + abs(UV.y) / size.y);
}
