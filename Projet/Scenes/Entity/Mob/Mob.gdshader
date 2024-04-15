shader_type canvas_item;

uniform float walkingAlpha : hint_range(-1.0, 1.0);
uniform float xOrientation : hint_range(-1.0, 1.0);

void vertex() {
	VERTEX.x += xOrientation * 50.0;
	
	//VERTEX.y -= xOrientation * (UV.x * 2.0 - 1.0) * 400.0 * abs(UV.y * 2.0 - 1.0);
	VERTEX.y -= xOrientation * (UV.x * 2.0 - 1.0) * 100.0;
	
}

float getStretchX(float xUV, float distortion) {
	float factor = mix(1.0, 1.1, distortion);
	return (xUV - 0.5) * factor + 0.5;
}

float getStretchY(float yUV, float distortion) {
	float factor = mix(0.98, 1.1, distortion);
	return (yUV - 0.5) * factor + 0.5;	
}

float interpolate() {
	return 0.0;
}

void computeWalkingUV(inout vec2 uv) {
	
	float centeredX = uv.x * 2.0 - 1.0;
	
	float alpha = (walkingAlpha + 1.0) / 2.0;
	float xAlternate = abs(uv.x - alpha);
	xAlternate = pow(abs(xAlternate), 3.0);
	uv = vec2(uv.x, uv.y * (xAlternate * 0.7 + 1.0));
}

void computeXOrientationUV(inout vec2 uv) {
	
	////uv.x = getStretchX(uv.x, xOrientation);
	uv.x += pow(abs(xOrientation), 2.0) * sign(xOrientation) * 0.2 * pow(abs((uv.x + sign(xOrientation) * 0.25) * 2.0 - 1.0), 3.0);
	
}

void timeIdle(inout vec2 uv) {
	float timeCosine = cos(TIME * 2.0) * 0.5 + 0.5;
	float timeSinine = sin(TIME * 2.0) * 0.5 + 0.5;
	uv.x = getStretchX(uv.x, 0.4 + timeCosine * 0.6);
	uv.y = getStretchY((uv.y), timeSinine * 1.0);
}

void fragment() {
	vec2 uv = UV;
	timeIdle(uv);
	computeWalkingUV(uv);
	computeXOrientationUV(uv);
	
	COLOR = texture(TEXTURE, uv);
}
