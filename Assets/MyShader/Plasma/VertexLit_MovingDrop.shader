Shader "Moein/VertexLit/MovingDrop"
{
    Properties
    {
        _Color("Tint Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}

        _Ambient("Ambient Intensity", Range(0, 1)) = 1
        _LightInt ("Light Intensity", Range(0, 1)) = 1

        [Space(20)]
        [Header(Plasma Fields)]
        [Space(10)]
        _Speed("Speed", Float) = 10
        _Plasma("Wieght", Range(0, 1)) = 10
		_Scale1("Vertical Scale", Float) = 2
		_Scale2("Horizontal Scale", Float) = 2
		_Scale3("Diagonal Scale", Float) = 2
		_Scale4("Circular Scale", Float) = 2

        _Direction("Direction", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "Assets/MyShader/utils.cginc"

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
                float4 color : COLOR;
                float plasma : COLOR1;
            };
            
            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Ambient;
            float _LightInt;

			float _Speed, _Plasma;
			float _Scale1,_Scale2,_Scale3,_Scale4;  

            float4 _Direction;      

            v2f vert (appdata v)
            {
                v2f o;

                float t = _Time.x * _Speed;

                o.plasma = abs(plasma(v.vertex.xy, t, _Scale1, _Scale2, _Scale3, _Scale4));
                v.vertex.xyz += v.normal * o.plasma * _Plasma;
                
                float3 norm = _Direction.xyz;
                float angle = dot(v.normal, norm);
                v.vertex.xyz = v.vertex.xyz + (angle > 0 ? norm * 1 / 10 : norm) * angle;

                

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                // lighing
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.color.rgb = UNITY_LIGHTMODEL_AMBIENT * _Ambient;

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half3 diffuse = lambert_shading(_LightColor0.rgb, _LightInt, worldNormal, lightDir);
                o.color.rgb += diffuse;
    
                return o;
            }
            
            fixed4 frag (v2f i) : SV_TARGET
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                col.rgb *= i.color;
                return col;

                // debug mode: render plasma color
                // fixed4 col = i.plasma;
	            // col.r = sin(i.plasma/4 * UNITY_PI);
				// col.g = sin(i.plasma/4 * UNITY_PI + UNITY_PI / 2);
				// col.b = sin(i.plasma/4 * UNITY_PI + UNITY_PI);
                // return col * _Color;
            }

            ENDCG
        }
    }
}