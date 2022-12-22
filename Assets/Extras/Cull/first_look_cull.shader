Shader "TutorialShaders/FirstLookCull"
{
    Properties{

             
        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull("Cull", Float) = 0


    }

    SubShader{
        Tags {}
        Cull [_Cull]

        Pass
        {
        
        }    
    }
    FallBack "Diffuse"
}