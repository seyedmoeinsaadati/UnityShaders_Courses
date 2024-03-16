using UnityEngine;

[ExecuteInEditMode]
public class ImageEffectGaussian : MonoBehaviour
{
    [SerializeField] private Material material;

    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        // Create a temporary RenderTexture to hold the first pass.
        RenderTexture tmp =
            RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

        // Perform both passes in order.
        Graphics.Blit(src, tmp, material, 0);   // First pass.
        Graphics.Blit(tmp, dst, material, 1);   // Second pass.

        RenderTexture.ReleaseTemporary(tmp);
    }
}