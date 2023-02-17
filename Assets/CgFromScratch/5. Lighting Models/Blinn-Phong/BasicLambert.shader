Shader "ShaderCourse/_LightingModels/BasicLambert" {

    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Spec ("Specular",Range(0,1)) = 0.5
        _Gloss("Gloss", Range(0,1)) = 0.5
    }

    SubShader {
        Tags{
            "Queue"="Geometry"
        }
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uvMainTex;
        };

        fixed4 _Color;
        half _Spec;
        fixed _Gloss;
        // fixed4 _SpecColor; // warn:don't need this becuase untiy has _SpecColor as defauit.

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = _Color.xyz;

            // following line doesn't work because shader lighting is lambert and lambert lighting doesn't have specular.
            o.Specular = _Spec;
            o.Gloss = _Gloss;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
