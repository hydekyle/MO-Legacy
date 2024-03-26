using RPGSystem;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Transform target;
    public float smoothTime;
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
        transform.position = Vector3.SmoothDamp(transform.position, targetPos, ref currentVelocity, smoothTime);
    }

    public static void SetPosition(Vector3 targetPos)
    {
        var camPos = new Vector3(targetPos.x, targetPos.y, -10);
        Instance.transform.position = camPos;
    }

    public void SetTarget(Transform target, float? cameraVelocity = null)
    {
        if (cameraVelocity.HasValue) smoothTime = cameraVelocity.Value;
        this.target = target;
    }

    public void SetVelocity(CameraVelocity cameraVelocity)
    {
        switch (cameraVelocity)
        {
            case CameraVelocity.Instant: smoothTime = 0f; break;
            case CameraVelocity.High: smoothTime = 0.2f; break;
            case CameraVelocity.Normal: smoothTime = 0.4f; break;
            case CameraVelocity.Slow: smoothTime = 0.8f; break;
            case CameraVelocity.VerySlow: smoothTime = 1.5f; break;
            case CameraVelocity.Stopped: smoothTime = 9999f; break;
        }
    }
}
