Shader "ShaderCourse/ShaderInput"
{
    Properties
    {
        _myColor("Example Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {   
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uvMainTex;
            // float2 uv2MainTex;
            // float3 viewDir; // shaders can change the surface of a model depending on where the camera is(e.x. Rim Lighting)
            // float3 worldPos;
            // float3 worldRefl;
            // and others in Unity-API
        };

        fixed4 _myColor;

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = _myColor.rgb;
        }
        ENDCG
    }
}