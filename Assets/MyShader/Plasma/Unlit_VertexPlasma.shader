Shader "Moein/Unlit/VertexPlasma"
{
    Properties
    {
        _Color("Tint Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}


        [Space(20)]
        [Header(Plasma Fields)]
        [Space(10)]
        _Speed("Speed", Float) = 10
        _Plasma("Wieght", Range(0, 1)) = 10
		_Scale1("Vertical Scale", Float) = 2
		_Scale2("Horizontal Scale", Float) = 2
		_Scale3("Diagonal Scale", Float) = 2
		_Scale4("Circular Scale", Float) = 2
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float plasma : COLOR;
            };
            
            float4 _Color;
			float _Speed, _Plasma;
			float _Scale1,_Scale2,_Scale3,_Scale4;

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

            v2f vert (appdata v)
            {
                v2f o;
                float t = _Time.x * _Speed;

                o.plasma = plasma(v.vertex.xy, t, _Scale1, _Scale2, _Scale3, _Scale4);
                v.vertex.xyz += v.normal * o.plasma * _Plasma;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }
            
            fixed4 frag (v2f i) : SV_TARGET
            {
                fixed4 col = i.plasma;
	            // col.r = sin(i.plasma/4 * UNITY_PI);
				// col.g = sin(i.plasma/4 * UNITY_PI + UNITY_PI / 2);
				// col.b = sin(i.plasma/4 * UNITY_PI + UNITY_PI);
                return _Color;
            }

            ENDCG
        }
    }
}
