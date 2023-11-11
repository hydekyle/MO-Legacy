using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Transform target;
    public float velocity;
    Vector3 currentVelocity;
    public static CameraController Instance;

    void Awake()
    {
        if (Instance) Destroy(this.gameObject);
        else
        {
            Instance = this;
        }
    }

    void FixedUpdate()
    {
        var targetPos = new Vector3(target.position.x, target.position.y, -10);
        transform.position = Vector3.SmoothDamp(transform.position, targetPos, ref currentVelocity, velocity);
    }

    public static void SetPosition(Vector3 targetPos)
    {
        var camPos = new Vector3(targetPos.x, targetPos.y, -10);
        Instance.transform.position = camPos;
    }
}
