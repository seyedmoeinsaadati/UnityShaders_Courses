Shader "ShaderCourse/_Passes_Blending/Cull_off" 
{
    Properties{
        _mainTex("Texture", 2D) = "black"{}
    }
    SubShader
    {
        Tags{
            "Queue" ="Transparent"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull off
        
        Pass{
            SetTexture[_mainTex] { Combine texture}
        }    
        
    }
    FallBack "Diffuse"
}
