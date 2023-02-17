Shader "ShaderCourse/_LightingModels/BlinnPhongLightingModel" {

    Properties {
        _Color ("Color", Color) = (1,1,1,1)
    }

    SubShader {
        Tags{
            "Queue"="Geometry"
        }
        CGPROGRAM
        #pragma surface surf BlinnPhong

        half4 LightingBlinnPhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten){
            half3 halfway = normalize(lightDir + viewDir);
            half diff = max(0, dot(s.Normal, lightDir));

            float nh = max(0, dot(s.Normal, halfway));
            float spec = pow(nh, 48.0);
            
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec ) * atten;
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
