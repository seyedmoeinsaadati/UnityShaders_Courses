using UnityEngine;

#if UNITY_EDITOR
[ExecuteInEditMode]
#endif
public class OnRenderMaterial : MonoBehaviour
{
    public Material EffectMaterial;

    private void OnEnable()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, EffectMaterial);
    }

}