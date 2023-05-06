using UnityEngine;
using System.Collections;

public class ChangeSkybox : MonoBehaviour
{

    public ReflectionProbe reflectionProbe;
    public Material skyboxMaterial;


    void Update()
    {
        // Check for a key press to change the skybox material
        if (Input.GetKeyDown(KeyCode.Space))
        {
            RenderSettings.skybox = skyboxMaterial;

        }
    }
}