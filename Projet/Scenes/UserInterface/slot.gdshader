shader_type canvas_item;

uniform sampler2D noiseTexture: repeat_enable, filter_linear;

uniform vec4 outlineColor: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform vec2 randomOffset = vec2(0.0, 0.0);

uniform float cooldown: hint_range(0.0, 1.0);

void fragment() {
	
	//float test = mod(-TIME * 0.5, 1.0);
	//test = cooldown;

	float test = 1.0 - cooldown;
	
	float noise = 0.1 + texture(noiseTexture, UV * 0.75 + randomOffset * 128.5).r * 1.1;
	
	float stepNoise = step(test, noise) * sign(cooldown);
	float stepNoiseAhead = step(test + 0.1, noise) * sign(cooldown);
	
	float noiseOutline = stepNoise - stepNoiseAhead;
	
	COLOR.rgb = mix(COLOR.rgb, outlineColor.rgb, noiseOutline);
	COLOR.rgb -= stepNoiseAhead * 0.85;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
