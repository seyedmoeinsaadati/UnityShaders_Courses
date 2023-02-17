Shader "ShaderCourse/BumpEnv" {

    Properties {
        _myDiffuse ("Diffuse Texture", 2D) = "white"{}
        _myBump ("Bump Texture", 2D) = "bump"{}
        _mySlider("Bump Amount", Range(0, 10)) = 1
        _myBright("Brightness", Range(0, 10)) = 1
        _myCube("Cube Map", CUBE) = "white"{}
    }

    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_myDiffuse;
            float2 uv_myBump;
            float3 worldRefl; INTERNAL_DATA
        };

        samplerCUBE _myCube; 
        sampler2D _myDiffuse;
        sampler2D _myBump;
        half _mySlider, _myBright;

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = (tex2D(_myDiffuse, i.uv_myDiffuse)).rgb * _myBright;
            // o.Albedo = texCUBE(_myCube, i.worldRefl).rgb;
            o.Normal = UnpackNormal(tex2D(_myBump, i.uv_myBump)); // UnpackNormal() convert rgb channels to xyz
            o.Normal *= float3(_mySlider, _mySlider, 1);
            o.Emission = texCUBE(_myCube, WorldReflectionVector(i, o.Normal)).rgb;
        }
        ENDCG
    }

    Fallback "Diffuse"
}

// struct SurfaceOutput {
    //     fixed3 Albedo;      // diffuse color
    //     fixed3 Normal;      // tangent space normal, if written
    //     fixed3 Emission;
    //     half Specular;      // specular power in 0..1 range
    //     fixed Gloss;        // specular intensity
    //     fixed Alpha;        // alpha for transparencies
// }