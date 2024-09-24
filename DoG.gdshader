shader_type canvas_item;

uniform float STD1: hint_range(0.35, 4.0) = 1.0;
uniform float STD2: hint_range(0.35, 4.0) = 1.0;
uniform float brightness: hint_range(0.0, 10.0) = 1.0;

float gauss(int x, int y, float STD){
	return exp(-float(x * x + y * y) / (2.0 * STD * STD)) / (2.0 * PI * STD * STD);
}

void fragment() {
	float weightArray[41];
	int minSize = 20;
	float normWeight = -1.0; //normalizes pixel brightness based on amount of sampled gaussian function
	vec4 gray = vec4(0.229, 0.587, 0.114, 0.0); //For conversion to grayscale
	float pixelGray = 0.0;
	int size = min(int(STD2)*5, minSize);
	for(int i = -size; i <= size; i++)
	{
		for(int j = -size; j <= size; j++) //Runs from -X -> X, X being half the size of the array - 1
		{
			weightArray[j+minSize] = gauss(j, i, STD1) - gauss(j, i, STD2);
			normWeight += weightArray[j+minSize];
		}
		for(int k = -size; k <= size; k++)
		{
			 pixelGray += weightArray[k+minSize]*dot(texture(TEXTURE, UV + vec2(float(k)*TEXTURE_PIXEL_SIZE.x, float(i)*TEXTURE_PIXEL_SIZE.y)), gray);
		}
	}
	pixelGray /= normWeight;
	
	//COLOR = vec4(pixelGray, pixelGray, pixelGray, pixelGray)*brightness*3.0; //USE THIS LINE FOR TRANSPARENT BACKGROUND
	COLOR = vec4(pixelGray, pixelGray, pixelGray, 1)*brightness*3.0; //multiplied by 3 for clarity USE THIS LINE FOR BLACK BACKGROUND
}
