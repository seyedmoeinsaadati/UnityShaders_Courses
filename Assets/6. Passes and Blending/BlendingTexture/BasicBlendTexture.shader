Shader "ShaderCourse/_Passes_Blending/BasicBlendTexture" 
{
    Properties{
        _MainTex("Texture", 2D) = "black"{}
        _DecalTex("Decal Texture", 2D) = "black"{}
        [Toggle] _ShowDecal("show decal", Float) = 0
    }
    SubShader
    {
        Tags{
            "Queue" ="Geometry"
        }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex, _DecalTex;
        float _ShowDecal;

        struct Input {
            float2 uv_MainTex;
        };

        void surf(Input i, inout SurfaceOutput o){
            float4 a = tex2D(_MainTex, i.uv_MainTex);
            float4 b = tex2D(_DecalTex, i.uv_MainTex) * _ShowDecal;
            o.Albedo = b.r > 0.9 ? b.rgb : a.rgb ;
        }

        ENDCG
        
    }
    FallBack "Diffuse"
}
