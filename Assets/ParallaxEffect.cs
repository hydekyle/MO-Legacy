using UnityEngine;

public class ParallaxEffect : MonoBehaviour
{
    private float startPos;
    public new GameObject camera;
    public float parallaxFactor = 0.12f;

    void Start()
    {
        startPos = transform.position.x;
        camera = Camera.main.gameObject;
    }

    void Update()
    {
        float distance = (camera.transform.position.x * parallaxFactor) * -1;
        transform.position = new Vector3(startPos + distance, transform.position.y, transform.position.z);
    }
}
