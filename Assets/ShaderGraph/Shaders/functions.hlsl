// testing
void Add_float(in float a, in float b, out float _out)
{
	_out = a + b;
}

void Mul_float(in float a, in float b, out float _out)
{
	_out = a * b;
}

// CustomLight.hlsl
void CustomLight_float(out half3 direction)
{
#ifdef SHADERGRAPH_PREVIEW
	direction = half3(0, 0, 0);
#else
#if defined(UNIVERSAL_LIGHTING_INCLUDED)
	Light mainLight = GetMainLight();
	direction = mainLight.direction;
#endif
#endif
}