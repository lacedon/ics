shader_type canvas_item;

uniform vec4 lineColor: source_color = vec4(0.25, 0.25, 1.0, 1.0);
uniform float lineWidth: hint_range(0.0, 10.0) = 5.0;

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * lineWidth;
	
	float top = texture(TEXTURE, UV + vec2(0, size.y)).a;
	float topRight = texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	float right = texture(TEXTURE, UV + vec2(size.x, 0)).a;
	float bottomRight = texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	float bottom = texture(TEXTURE, UV + vec2(0, -size.y)).a;
	float bottomLeft = texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	float left = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	float topLeft = texture(TEXTURE, UV + vec2(-size.x, size.y)).a;

	float sum = top + topRight + right + bottomRight + bottom + bottomLeft + left + topLeft;
	float outline = min(sum, 1.0);

	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, lineColor, outline - color.a);
}