using UnityEngine;

#if UNITY_EDITOR
[ExecuteInEditMode]
#endif
public class CameraEffect : MonoBehaviour
{
    public bool autoUpdate;
    public Material material;

    void Start()
    {
        if (null == material || null == material.shader || !material.shader.isSupported)
        {
            enabled = false;
            return;
        }
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (autoUpdate)
        {
            Graphics.Blit(source, destination, material);
        }        
    }

}
