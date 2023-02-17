Shader "ShaderCourse/_Passes_Blending/BasicStencilMask" 
{
    Properties
    {
        _MainTex ("Diffuse", 2D) = "white"{}
    }
    SubShader
    {
        Tags{
            "Queue" ="Geometry"
        }

        ColorMask 0
        ZWrite off
        Stencil{
            Ref 1
            Comp always
            Pass replace
        }

        CGPROGRAM
        #pragma surface surf Lambert 

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input i, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, i.uv_MainTex);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
