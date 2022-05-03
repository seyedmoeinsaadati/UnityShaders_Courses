Shader"Moein/RimLighting"{
    Properties{
        [HDR]
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPower ("Rim Power", Range(-1, 10)) = 0
    }

    SubShader{

        CGPROGRAM

        #pragma surface surf Lambert

        struct Input{
            float3 viewDir;
        };

        half _RimPower;
        float4 _RimColor;

        void surf(Input i, inout SurfaceOutput o){
            half rim = pow(1-dot(normalize(i.viewDir), o.Normal), _RimPower);
            o.Emission = _RimColor * rim;
        }

        ENDCG
    }

    Fallback "Diffuse"
}