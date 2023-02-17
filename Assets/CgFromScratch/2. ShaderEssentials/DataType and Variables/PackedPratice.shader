Shader "ShaderCourse/PackedPractice"
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
        };

        // Basic Data Types
        // float    - used for texture cordinations, world poistions and calculation
        // half     - used for short vector, direction, dynamic color range
        // fixed    - used for colors and simple color operation
        // int      - used for counter and indices

        // Texture Data Types
        // sampler2D        - for images
        // sample2D_half    - for low precision
        // sampler2D_float  - for hight precision

        // samplerCUBE  - for cubeMap
        // sampleCUBE_half    - for low precision
        // samplerCUBE_float  - for hight precision

        // Packed Arrays (0, 1, 2, 3) or (x, y, z, w) or (r, g, b, a)
        // int2-3-4  
        // float 2-3-4
        // ...

        // Packed matrices
        // float4x4, [DataType][RowNum][ColNum]
        // float myValue = matrix._m00; // _mRC (raw, column)
        // fixed4 value = matrix._m00_m01_m02_m03; or value = matrix[0]

        fixed4 _myColor;

        void surf (Input i, inout SurfaceOutput o){
            // o.Albedo.x = _myColor.r;
            // o.Albedo = _myColor.gbr;
            o.Albedo = _myColor.rgb;
        }

        ENDCG
    }
}