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

float circle (float2 p, float center, float radius, float smooth)
{
    float c = length(p - center) - radius;
    return smoothstep(c - smooth, c + smooth, radius);
}

float plasma(float2 pos, float t, float verticalSpeed, float horizontalSpeed, float diagonalSpeed, float circularSpeed){
                
    //vertical
    float c = sin(pos.x * verticalSpeed + t);

    // //horizontal
    c += sin(pos.y * horizontalSpeed + t);

    // // diagonal
    c += sin(diagonalSpeed * (sin(t/2.0) * pos.x + cos(t/3) * pos.y) + t);

    // // circular
    float c1 = pow(pos.x + .5 * sin(t/5), 2);
    float c2 = pow(pos.y + .5 * cos(t/5), 2);
    c += sin(sqrt(circularSpeed * (c1 + c2) + t));

    return c;
}