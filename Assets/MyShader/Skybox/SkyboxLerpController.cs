using UnityEngine;
using System.Collections;

public class SkyboxLerpController : MonoBehaviour
{
    [SerializeField] private float duration;
    [SerializeField] private AnimationCurve t;

    [SerializeField] private float min, max;
    [SerializeField] private string lerpMaterialField = "_Lerp";

    private Material skyboxMaterial;
    private float timer, tValue;

    private void Start()
    {
        skyboxMaterial = RenderSettings.skybox;
    }

    public void StartLerp()
    {
        enabled = true;
    }

    public void StopLerp()
    {
        timer = 0;
        enabled = false;
    }

    private void Update()
    {
        timer += Time.deltaTime / duration;
        tValue = Mathf.Lerp(min, max, t.Evaluate(timer));
        skyboxMaterial.SetFloat(lerpMaterialField, tValue);
        if (timer >= 1) StopLerp();
    }

}