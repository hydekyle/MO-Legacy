using UnityEditor.SceneManagement;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[ExecuteInEditMode]
public class ScaleUnifier : MonoBehaviour
{
    void Start()
    {
        if (!Application.isPlaying)
        {
            UnifyScale();
        }
    }

    void UnifyScale()
    {
        // Get the object's mesh filter
        MeshFilter meshFilter = GetComponent<MeshFilter>();

        // Get the original mesh
        Mesh originalMesh = meshFilter.sharedMesh;

        // Duplicate the original mesh
        Mesh newMesh = DuplicateMesh(originalMesh);

        // Apply the object's scale to the new mesh
        Vector3[] vertices = newMesh.vertices;
        for (int i = 0; i < vertices.Length; i++)
        {
            vertices[i] = Vector3.Scale(vertices[i], transform.localScale);
        }
        newMesh.vertices = vertices;
        newMesh.RecalculateBounds();
        newMesh.RecalculateNormals();

        // Assign the new mesh to the object
        meshFilter.sharedMesh = newMesh;

        // Set the object's scale to 1 to maintain shape
        transform.localScale = Vector3.one;
        Debug.LogWarning(gameObject.name + ": <color=orange>Check the collider and reset or modify if needed.</color> You can remove the script; the scale will stay unified.", this);
DestroyImmediate(this);
    }

    Mesh DuplicateMesh(Mesh originalMesh)
    {
        Mesh newMesh = new Mesh();
        newMesh.vertices = originalMesh.vertices;
        newMesh.normals = originalMesh.normals;
        newMesh.uv = originalMesh.uv;
        newMesh.triangles = originalMesh.triangles;
        return newMesh;
    }

}
