Shader "Unlit/ShowDepth"
{
    Properties {
        _Color ("Color", COlor) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
    }
   SubShader
   {
      Tags { "RenderType"="Opaque" }
        Cull Off ZWrite Off ZTest Always 
         
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
         };

         struct v2f
         {
            float2 uv : TEXCOORD0;
            float4 vertex : SV_POSITION;
         };

         sampler2D _CameraDepthTexture;
         sampler2D _MainTex;
         float4 _MainTex_ST;
         float4 _Color;
         
         v2f vert (appdata v)
         {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            
            return o;
         }
         
         fixed4 frag (v2f i) : SV_Target
         {
             float depth = 1 - Linear01Depth(tex2D(_CameraDepthTexture, i.uv));
             return depth * _Color;
         }
         ENDCG
      }
   }
}