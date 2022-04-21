Shader "ShaderCourse/NormalSliderShader" {

    Properties {
        _mySliderX("Nx ", Range(-1, 1)) = 1
        _mySliderY("Ny", Range(-1, 1)) = 1
        _mySliderZ("Nz", Range(-1, 1)) = 1
    }

    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_myDiffuse;
        };

        half _mySliderX, _mySliderY, _mySliderZ;

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = 1;
            o.Normal = float3(_mySliderX, _mySliderY, _mySliderZ);
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