Shader "ShaderCourse/_LightingModels/BasicLambertLightingModel" {

    Properties {
        _Color ("Color", Color) = (1,1,1,1)
    }

    SubShader {
        Tags{
            "Queue"="Geometry"
        }
        CGPROGRAM
        #pragma surface surf BasicLambert

        half4 LightingBasicLambert(SurfaceOutput s, half3 lightDir, half atten){
            half NdotL = dot(s.Normal, lightDir);
            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb *(NdotL * atten);
            c.a = s.Alpha;
            return c;
        }

        struct Input {
            float2 uvMainTex;
        };

        fixed4 _Color;

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = _Color.xyz;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
