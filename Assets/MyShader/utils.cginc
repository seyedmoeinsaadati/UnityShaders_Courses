float random (float2 uv)
{
    return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
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