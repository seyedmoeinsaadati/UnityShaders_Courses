Shader "ShaderCourse/Properties"
{
    Properties
    {
        _myColor("Example Color", COLOR) = (1,1,1,1)
        _myRange("Example Range", Range(0, 5)) = 0.5
        _myTex("Example 2D Texture", 2D) = "white"{}
        _myCube("Example CUBE Map", CUBE) = ""{}
        _myFloat("Example Float", Float) = 0.5
        _myVector("Example Vector", Vector) = (1,1,1,1)
        [Toggle] _Toggle("show decal", Float) = 0; // there is not bool value in shaders
    }
    SubShader
    {   
        CGPROGRAM
        #pragma surface surf Lambert

        fixed4 _myColor;
        half _myRange;
        sampler2D _myTex;
        samplerCUBE _myCube;
        float _myFloat;
        float4 _myVector;
        float _Toggle;

        struct Input {
            float2 uv_myTex;
            float3 worldRefl; INTERNAL_DATA
        };

        void surf (Input i, inout SurfaceOutput o){

            o.Albedo = tex2D(_myTex, i.uv_myTex).rgb * _myColor * _myRange;
            //o.Emission = texCUBE(_myCube, i.worldRefl).rgb;
            o.Normal = WorldReflectionVector(i, o.Normal);
        }

        ENDCG
    }
}