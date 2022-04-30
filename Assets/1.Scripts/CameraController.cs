using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Transform target;
    public float velocity;
    Vector3 currentVelocity;
    public static CameraController Instance;

    void Awake()
    {
        Instance = this;
    }

    void Update()
    {
        var targetPos = new Vector3(target.position.x, target.position.y, -10);
        transform.position = Vector3.SmoothDamp(transform.position, targetPos, ref currentVelocity, velocity);
    }

    public static void SetPosition(Vector3 camPos)
    {
        var targetPos = new Vector3(camPos.x, camPos.y, -10);
        Instance.transform.position = targetPos;
    }
}
