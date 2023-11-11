Shader "Unlit/ShieldShader"
{
   Properties
   {
      _MainTex ("Texture", 2D) = "white" {}
      _Color ("Color", Color) = (1,1,1,1)
      _Edge ("Edge Intensity", Range(0.1,10)) = 2
   }
   SubShader
   {
      Tags {
          "RenderType"="Transparent"
          "Queue"="Transparent"
      }
      Blend One One
      ZWrite Off
      Cull Off

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
            float3 normal : NORMAL;
         };

         struct v2f
         {
            float2 uv : TEXCOORD0;
            float2 screenuv : TEXCOORD1;
            float3 objectPos : TEXCOORD2;
            float4 vertex : SV_POSITION;
            float depth : DEPTH;
            float3 normal : NORMAL;
            float3 viewDir : TEXCOORD3;
         };

         sampler2D _MainTex;
         float4 _MainTex_ST;
         float4 _Color;
         sampler2D _CameraDepthNormalsTexture;
         float _Edge;
         
         v2f vert (appdata v)
         {
         
            v2f o;
            o.vertex = UnityObjectToClipPos (v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);

            o.screenuv = ((o.vertex.xy / o.vertex.w) + 1) / 2;
            o.screenuv.y = 1 - o.screenuv.y;
            o.depth = -mul(UNITY_MATRIX_MV, v.vertex).z * _ProjectionParams.w;
             
            o.normal = UnityObjectToWorldNormal(v.normal);
            o.viewDir = normalize(UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex)));
            o.objectPos = v.vertex.xyz;        
            
             return o;
            
         }
         
         // https://www.desmos.com/calculator/xfmf9o043x
         float triWave(float t, float offset, float yOffset) {
             return saturate(abs(frac(offset + t) * 2 - 1) + yOffset);
         }
         
         fixed4 texColor(v2f i, float rim) {
             fixed4 mainTex = tex2D(_MainTex, i.uv);
             mainTex.r *= triWave(_Time.x * 5, abs(i.objectPos.y) * 2, -0.7) * 6;
             mainTex.g *= saturate(rim) * (sin(_Time.z + mainTex.b * 5) + 1);
            return mainTex.r * _Color + mainTex.g * _Color;
         }
         
         fixed4 frag (v2f i) : SV_Target
         {

                float3 normalValues;
                float screenDepth;

             // unpack the depth from the depth texture
             DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.screenuv), screenDepth, normalValues);

             // find the distance between screen depth and fragment depth
             float diff = screenDepth - i.depth;
             
             float intersect = 0;
             
             if (diff > 0) {
                 // _ProjectionParams.w = 1 / far plane
                 intersect = 1 - smoothstep(0, _ProjectionParams.w * 0.3, diff);
             }
             
             float rim = 1 - abs(dot(i.normal, normalize(i.viewDir))) * 2;
             float northPole = (i.objectPos.y - 0.45) * 20;
             float glow = max(max(intersect, rim), northPole);
             
                fixed4 sweetColor = fixed4(lerp(_Color.rgb, fixed3(1,1,1), pow(glow, _Edge)), 1);

                fixed4 hexes = texColor(i, rim);

             fixed4 col = _Color * _Color.a + sweetColor * glow + hexes;
            return col;
            
         }
         ENDCG
      }
   }
}