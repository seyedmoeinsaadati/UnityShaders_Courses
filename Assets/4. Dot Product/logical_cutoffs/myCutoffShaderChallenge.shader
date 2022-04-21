Shader "ShaderCourse/myCutoffShaderChallenge" {
    Properties{
        _firstColor("Edge Color 1", COLOR) = (1,1,1,1)
        _secondColor("Edge Color 2", COLOR) = (0,0,0,1)
        _myDiffuse("Texture", 2D) = "white"{}
        _mySlider("Rim Power", Range(0.5, 8)) = 1
        _myStripWidth("Strip Width", Range(0, 1)) = 1
    }
    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float3 viewDir; 
            float3 worldPos;
            float2 uv_myDiffuse;
        };

        sampler2D _myDiffuse;
        float4 _firstColor, _secondColor;
        half _mySlider, _myStripWidth;
        void surf (Input i, inout SurfaceOutput o){
            half rim = 1 - saturate(dot(normalize(i.viewDir), o.Normal));
            //o.Albedo = tex2D(_myDiffuse, i.uv_myDiffuse);
            o.Emission = frac(i.worldPos.y * 10 * 0.5) > _myStripWidth ? _firstColor * pow(rim, _mySlider): _secondColor * pow(rim, _mySlider);
        }
        ENDCG
    }

    Fallback "Diffuse"
}