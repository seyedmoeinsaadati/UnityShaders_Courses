Shader "ShaderCourse/_Passes_Blending/Leaves" {

    Properties {
        _MainTex ("Texture", 2D) = "white"{}
        _AlphaSlider ("Alpha channel", Range(0, 1)) = 1
    }

    SubShader {
        Tags{
            //"Queue"="Geometry"
            "Queue"="Transparent"
        }
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        struct Input {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        half _AlphaSlider;

        void surf (Input i, inout SurfaceOutput o){
            fixed4 c = tex2D(_MainTex, i.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = _AlphaSlider * c.a;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
