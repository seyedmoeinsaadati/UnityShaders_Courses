Shader "ShaderCourse/_Challenges/StandardPBRChallenge1" {

    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MettalicTex ("Mettalic Tex (R)", 2D) = "white"{} // it's must to be greyscale
        _Metallic ("Mettalic", Range(0,1)) = 1
        _EmissionSlider("Emission Slider", Range(0, 10)) = 1
    }

    SubShader {
        Tags{
            "Queue"="Geometry"
        }
        CGPROGRAM
        #pragma surface surf Standard

        struct Input {
            float2 uv_MettalicTex;
        };

        fixed4 _Color;
        half _EmissionSlider;
        sampler2D _MettalicTex;
        half _Metallic;

        void surf (Input i, inout SurfaceOutputStandard o){
            o.Albedo = _Color.rgb;
            o.Smoothness = tex2D(_MettalicTex, i.uv_MettalicTex).r;
            o.Metallic = _Metallic;
            o.Emission = tex2D(_MettalicTex, i.uv_MettalicTex).r * _EmissionSlider;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
