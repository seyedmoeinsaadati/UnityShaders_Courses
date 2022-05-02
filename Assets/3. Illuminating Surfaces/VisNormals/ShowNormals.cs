using UnityEngine;

[ExecuteInEditMode]
public class ShowNormals : MonoBehaviour
{

    [Range(-1, 1)]
    public float nx;

    [Range(-1, 1)]
    public float ny;

    [Range(-1, 1)]
    public float nz;

    //to display length
    public float normal_length;
    public float normal_scale = 1;

    // Update is called once per frame
    void Update()
    {

        Mesh mesh = GetComponent<MeshFilter>().sharedMesh;

        Vector3[] vertices = mesh.vertices;
        Vector3[] normals = mesh.normals;

        Vector3 modNormal = new Vector3(normals[0].x * nx, normals[0].y * ny, normals[0].z * nz);
        normal_length = modNormal.magnitude;

        for (var i = 0; i < normals.Length; i++)
        {
            Vector3 pos = vertices[i];
            pos.x *= transform.localScale.x;
            pos.y *= transform.localScale.y;
            pos.z *= transform.localScale.z;
            pos += transform.position;

            Vector3 posRot = transform.rotation * pos;
            normals[i].x *= nx;
            normals[i].y *= ny;
            normals[i].z *= nz;

            Debug.DrawLine
            (
                posRot,
                posRot + normals[i] / 2 * normal_scale, Color.white);
        }
    }
}
