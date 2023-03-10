using System;
using UnityEngine;

public class DropControl : MonoBehaviour
{
    [SerializeField] private Material material;
    [SerializeField] private MeshRenderer meshRenderer;

    private void Reset()
    {
        meshRenderer = GetComponent<MeshRenderer>();
    }

    private void Start()
    {
        if (meshRenderer != null)
        {
            material = meshRenderer.material;
        }
    }

    public float speed = 1;

    public Vector3 direction = Vector3.zero;
    public Vector3 shaderDirection = Vector3.zero;

    // Update is called once per frame
    private void Update()
    {
        float x = Input.GetAxis("Horizontal");
        float z = Input.GetAxis("Vertical");
        float y = Input.GetAxis("Height");
        direction = new Vector3(x, y, z);
        transform.Translate(direction * speed * Time.deltaTime);

        if (direction != Vector3.zero)
        {
            shaderDirection = Vector3.Lerp(shaderDirection, direction, speed/2 * Time.deltaTime);
        }
        else
        {
            shaderDirection = Vector3.Lerp(shaderDirection, Vector3.zero, speed * Time.deltaTime);
        }

        material.SetVector("_Direction",
            new Vector4(shaderDirection.x, shaderDirection.y, shaderDirection.z, 0));
    }
}