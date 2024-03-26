using Moein.Core;
using UnityEngine;

[ExecuteInEditMode]
public class Vector2Color : MonoBehaviour
{
    public Vector3 vector;
    public Color color;

    public Transform point;

    public string colorCode;

    private void Update()
    {
        vector = point.position;
     

        colorCode = color.ColorToHex();
    }

    public Color ConvertVectorToColor(Vector3 direction)
    {
        Color color = Color.white;
        color.r = Mathf.InverseLerp(-1, 1, direction.x);
        color.g = Mathf.InverseLerp(-1, 1, direction.y);
        color.b = Mathf.InverseLerp(-1, 1, direction.z);
        return color;
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = color;
        Gizmos.DrawLine(Vector3.zero, point.position);
    }
}
