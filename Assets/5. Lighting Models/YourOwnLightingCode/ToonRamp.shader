Shader "ShaderCourse/_LightingModels/ToonRamp" {

    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _RampMap("Ramp", 2D) = "white"{}
    }

    SubShader {
        Tags{
            "Queue"="Geometry"
        }
        CGPROGRAM
        #pragma surface surf ToonRamp

        fixed4 _Color;
        sampler2D _RampMap;

        half4 LightingToonRamp(SurfaceOutput s, half3 lightDir, half atten){

            half diff = 1- dot(s.Normal, lightDir);
            float h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D (_RampMap, rh).rgb;

            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * ramp;
            c.a = s.Alpha;
            return c;
        }

        struct Input {
            float2 uvMainTex;
        };

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = _Color.xyz;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
