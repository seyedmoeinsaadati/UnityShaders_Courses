Shader "ShaderCourse/_Challenges/StandardSpecPBRChallenge2" {

    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MettalicTex ("Mettalic Tex (R)", 2D) = "white"{} // it's must to be greyscale

        // _Metallic ("Mettalic", Range(0,1)) = 1
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Roughness ("Roughness", Range(0, 2)) = 1
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
        half _Roughness;
        //half _Metallic;

        void surf (Input i, inout SurfaceOutputStandardSpecular o){
            o.Albedo = _Color.rgb;
            half val = tex2D(_MettalicTex, i.uv_MettalicTex).r;
            o.Smoothness = _Roughness - val;
            //o.Specular = _Metallic;
            o.Specular =  _SpecColor;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
