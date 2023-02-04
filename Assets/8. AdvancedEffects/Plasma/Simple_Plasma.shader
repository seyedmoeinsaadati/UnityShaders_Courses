Shader "Holistic/Waves"
{
	Properties
	{
		_Tint("Tint Color", Color) = (1,1,1,1)
		_Speed("Speed", Range(1,100)) = 10
		_Scale1("Scale 1", Range(.1,10)) = 2
		_Scale2("Scale 2", Range(.1,10)) = 2
		_Scale3("Scale 3", Range(.1,10)) = 2
		_Scale4("Scale 4", Range(.1,10)) = 2
	}
	SubShader
    {
		CGPROGRAM
			#include "UnityCG.cginc"

			#pragma surface surf Lambert
			struct Input{
				float2 uv_MainTex;
				float3 worldPos;
			};

			float4 _Tint;
			float _Speed;
			float _Scale1,_Scale2,_Scale3,_Scale4;

			void surf(Input IN, inout SurfaceOutput o){

				float t = _Time.x * _Speed;
				
				//vertical
				float4 c = sin(IN.worldPos.x * _Scale1 + t);

				//horizontal
				c += sin(IN.worldPos.z * _Scale2 + t);

				// diagonal
				c += sin(_Scale3 * (sin(t/2.0) * IN.worldPos.x + cos(t/3) * IN.worldPos.z) + t);

				// circular
				float c1 = pow(IN.worldPos.x + .5 * sin(t/5), 2);
				float c2 = pow(IN.worldPos.z + .5 * cos(t/5), 2);
				c += sin(sqrt(_Scale4 * (c1 + c2) + 1 + 5));

				o.Albedo.r = sin(c/4 * UNITY_PI);
				o.Albedo.g = sin(c/4 * UNITY_PI + UNITY_PI / 2);
				o.Albedo.b = sin(c/4 * UNITY_PI + UNITY_PI);
				o.Albedo *= _Tint;  
			}
		ENDCG
    }
	Fallback "Diffuse"
}