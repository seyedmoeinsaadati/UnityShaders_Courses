Shader "ShaderCourse/_Challenges/LightingModelChallenge3" {

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

        float4 _Color;
        sampler2D _RampMap;
        
        float4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = dot (s.Normal, lightDir);
            float h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D(_RampMap, rh).rgb;
            
            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
            c.a = s.Alpha;
            return c;
        }
        

        struct Input {
            float2 uvMainTex;
            float3 viewDir;
        };

        void surf (Input i, inout SurfaceOutput o){
            half diff = 1- dot(o.Normal, i.viewDir);
            float h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D (_RampMap, rh).rgb;

            o.Albedo = ramp * _Color;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
