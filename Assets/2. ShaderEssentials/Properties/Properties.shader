Shader "ShaderCourse/Properties"
{
    Properties
    {
        [HDR] _myColor("Example Color", COLOR) = (1,1,1,1)
        _myRange("Example Range", Range(0, 5)) = 0.5
        _myTex("Example 2D Texture", 2D) = "white"{}
        _myCube("Example CUBE Map", CUBE) = ""{}
        _myFloat("Example Float", Float) = 0.5
        _myVector("Example Vector", Vector) = (1,1,1,1)
    
        [Enum(On, 1, Off, 0)] _MyEnum ("My Enum", Int) = 1
        [KeywordEnum(None, Add, Multiply)] _Overlay("Keyword Enum", Float) = 0
 
        // Will set "ENABLE_FANCY" shader keyword when set.
        [Toggle(ENABLE_FANCY)] _Fancy("Keyword toggle", Float) = 0

        [Header(Main Color)]
        [Toggle] _UseColor("Enabled?", Float) = 1
        _Color("Main Color", Color) = (1,1,1,1)
        [Space(5)]

        [Header(Base(RGB))]
        [Toggle] _UseMainTex("Enabled?", Float) = 1
        _MainTex("Base (RGB)", 2D) = "white" {}
		//[NoScaleOffset] _MainTex("Base (RGB)", 2D) = "white" {}
        [Space(5)]

        [Header(Blend State)]
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend", Float) = 1 //"One"
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DestBlend", Float) = 0 //"Zero"
        [Space(5)]

        [Header(Other)]
        [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Float) = 2 //"Back"
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4 //"LessEqual"
        [Enum(Off,0,On,1)] _ZWrite("ZWrite", Float) = 1.0 //"On"
        [Enum(UnityEngine.Rendering.ColorWriteMask)] _ColorWriteMask("ColorWriteMask", Float) = 15 //"All"

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

            // #ifdef ENABLE_FANCY
            //     return float4(1, 0, 0, 1);
            // #else
            //     return (float4)1;
            // #endif

            o.Albedo = tex2D(_myTex, i.uv_myTex).rgb * _myColor * _myRange;
            //o.Emission = texCUBE(_myCube, i.worldRefl).rgb;
            o.Normal = WorldReflectionVector(i, o.Normal);
        }

        ENDCG
    }
}