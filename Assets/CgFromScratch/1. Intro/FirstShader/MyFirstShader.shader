Shader "ShaderCourse/MyFirstShader" {

    Properties {
        _myColor ("Example Colour", Color) = (1,1,1,1)
        _myEmission ("Example Emission", Color) = (1,1,1,1)
    }

    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        // Input data from the model's mesh (vertices, normals, uvs, ...)
        struct Input {
            float2 uvMainTex;
        };

        fixed4 _myColor;
        fixed4 _myEmission;

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = _myColor.xyz;
            o.Emission =_myEmission.rgb;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
