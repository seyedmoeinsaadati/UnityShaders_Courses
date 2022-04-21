Shader "ShaderCourse/NegativeColor"
{
    Properties
    {
        _myColor("Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {   
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uvMainTex;
        };

        fixed4 _myColor;

        void surf (Input i, inout SurfaceOutput o){
            
            // negative effect 
            _myColor.r =  1 - _myColor.r;
            _myColor.g =  1 - _myColor.g;
            _myColor.b =  1 - _myColor.b;
            o.Albedo = _myColor.rgb;
            
        }

        ENDCG
    }
}