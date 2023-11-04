// Noises
float random (float2 uv)
{
    return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
}

float plasma(float2 pos, float t, float verticalScale, float horizontalScale, float diagonalScale, float circularScale){
                
    //vertical
    float c = sin((pos.x + t) * verticalScale);

    // horizontal
    c += sin((pos.y + t) * horizontalScale);

    // diagonal
    c += sin(diagonalScale * ((sin(t/2.0) * pos.x + cos(t/3) * pos.y) + t));

    // circular
    float c1 = pow(pos.x + .5 * sin(t/5), 2);
    float c2 = pow(pos.y + .5 * cos(t/5), 2);
    c += sin(sqrt(circularScale * (c1 + c2 + t)));

    return c;
}

float plasma3D(float3 pos, float t, float xScale, float yScale, float zScale, float circularScale){
                
    // X axis
    float c = sin((pos.x + t) * xScale);

    // Y axis
    c += sin((pos.y + t) * yScale);

    // Z axis
    c += sin((pos.z + t) * zScale);

    // circular
    float c1 = pow(pos.x + .5 * sin(t/5), 2);
    float c2 = pow(pos.y + .5 * cos(t/5), 2);
    c += sin(sqrt(circularScale * (c1 + c2 + t)));

    return c;
}


// Mathematics
float invLerp(float a, float b, float value){
    return (value - b) / (b-a);
}

float2 invLerp(float2 a, float2 b, float2 value){
    return (value - b) / (b-a);
}

float3 invLerp(float3 a, float3 b, float3 value){
    return (value - b) / (b-a);
}

float4 invLerp(float4 a, float4 b, float4 value){
    return (value - b) / (b-a);
}


void rotate(float2 UV, float2 center, float angle,out float2 Out)
{
    angle = angle * (UNITY_PI/180.0f);
    UV -= center;
    float s = sin(angle);
    float c = cos(angle);
    float2x2 rMatrix = float2x2(c, -s, s, c);
    rMatrix *= 0.5;
    rMatrix += 0.5;
    rMatrix = rMatrix * 2 - 1;
    UV.xy = mul(UV.yx, rMatrix);
    UV += center;
    Out = UV;
}

float circle (float2 p, float center, float a, float b, float radius, float smooth)
{
    float2 c = p - center;
    c.x /= a;// length(p.x - center.x)/a - radius;
    c.y /= b;// length(p.y - center.y)/b - radius;  
    return 1.-smoothstep(radius-(radius*smooth), radius+(radius*0.01), dot(c,c)*4.0);
    // return smoothstep(c - smooth, c + smooth, radius);
}


// Lighing Methods
float3 lambert_shading(float3 colorRefl, float lightInt, float3 normal, float3 lightDir)
{
    return colorRefl * lightInt * max(0, dot(normal, lightDir));
}

float3 specular_shading(float3 colorRefl, float specularInt, float3 normal, float3 lightDir, float3 viewDir, float specularPow)
{
    float3 h = normalize(lightDir + viewDir);
    return colorRefl * specularInt * pow(max (0 , dot(normal, h)), specularPow);
}