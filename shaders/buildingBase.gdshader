shader_type canvas_item;

uniform vec4 color: source_color = vec4(0.25, 0.25, 1.0, 1.0);

void fragment() {
	vec4 baseColor = texture(TEXTURE, UV);
	// COLOR = mix(baseColor, color, 1);
	COLOR = color;
}
