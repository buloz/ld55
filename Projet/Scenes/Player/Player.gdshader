shader_type canvas_item;

//To create offset or give unique property between same shader
uniform float randomFloat : hint_range(0.0, 1.0);

uniform float walkingAlpha : hint_range(-1.0, 1.0);
uniform float xOrientation : hint_range(-1.0, 1.0);
uniform float damageState : hint_range(0.0, 1.0);

void vertex() {
	VERTEX.x += xOrientation * 50.0;
	
	//VERTEX.y -= xOrientation * (UV.x * 2.0 - 1.0) * 400.0 * abs(UV.y * 2.0 - 1.0);
	VERTEX.y -= xOrientation * (UV.x * 2.0 - 1.0) * 400.0;
	
	float touchSmoothRatio = pow(damageState, 2);
	VERTEX.x += (sin(touchSmoothRatio * 30.0)) * 125.0 * (1.0 - UV.y);
	
}

float getStretchX(float xUV, float distortion) {
	float factor = mix(0.7, 1.0, distortion);
	return (xUV - 0.5) * factor + 0.5;
}

float getStretchY(float yUV, float distortion) {
	float factor = mix(0.95, 1.0, distortion);
	return (yUV - 0.5) * factor + 0.5;	
}

float interpolate() {
	return 0.0;
}

void computeWalkingUV(inout vec2 uv) {
	
	float centeredX = uv.x * 2.0 - 1.0;
	
	float alpha = (walkingAlpha + 1.0) / 2.0;
	float xAlternate = abs(uv.x - alpha);
	xAlternate = pow(abs(xAlternate), 2.0);
	uv = vec2(uv.x, uv.y * (xAlternate * 0.8 + 0.9));
}

void computeXOrientationUV(inout vec2 uv) {
	
	////uv.x = getStretchX(uv.x, xOrientation);
	uv.x += pow(abs(xOrientation), 2.0) * sign(xOrientation) * 0.2 * pow(abs((uv.x + sign(xOrientation) * 0.1) * 2.0 - 1.0), 2.5);
	
}

void timeIdle(inout vec2 uv) {
	float timeCosine = cos(TIME * 2.0 + randomFloat * -14558.0) * 0.5 + 0.5;
	float timeSinine = sin(TIME * 2.0 + randomFloat * -78454.0) * 0.5 + 0.5;
	uv.x = getStretchX(uv.x, 0.4 + timeCosine * 0.6);
	uv.y = getStretchY((uv.y), timeSinine * 1.0);
}

void fragment() {

	vec2 uv = UV;
	timeIdle(uv);
	computeWalkingUV(uv);
	computeXOrientationUV(uv);
	
	
	COLOR = texture(TEXTURE, uv);
	
	COLOR.r += damageState * 0.5;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
