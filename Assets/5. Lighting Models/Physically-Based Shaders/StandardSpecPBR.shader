Shader "ShaderCourse/_LightingModels/StandardSpecPBR" {

    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MettalicTex ("Mettalic Tex (R)", 2D) = "white"{} // it's must to be greyscale

        // _Metallic ("Mettalic", Range(0,1)) = 1
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
    }

    SubShader {
        Tags{
            "Queue"="Geometry"
        }
        CGPROGRAM
        #pragma surface surf StandardSpecular

        struct Input {
            float2 uv_MettalicTex;
        };

        fixed4 _Color;
        sampler2D _MettalicTex;

        //half _Metallic;

        void surf (Input i, inout SurfaceOutputStandardSpecular o){
            o.Albedo = _Color.rgb;
            o.Smoothness = tex2D(_MettalicTex, i.uv_MettalicTex).r;

            //o.Specular = _Metallic;
            o.Specular = _SpecColor;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
