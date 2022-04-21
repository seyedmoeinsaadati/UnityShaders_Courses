Shader "ShaderCourse/MyFirstShader" {

    Properties {
        _myColor ("Example Colour", Color) = (1,1,1,1)
        _myNormal ("Example Normal", Color) = (1,1,1,1) // challenge 1
        _myEmission ("Example Emission", Color) = (1,1,1,1)
    }

    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uvMainTex;
        };

        fixed4 _myColor;
        fixed4 _myEmission;
        fixed4 _myNormal; // challenge 1

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = _myColor.xyz;
            o.Emission =_myEmission.rgb;
            o.Normal = _myNormal.rgb; // challenge 1
        }
        ENDCG
    }

    Fallback "Diffuse"
}
