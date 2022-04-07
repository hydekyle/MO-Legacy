using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : Entity
{
    void Update()
    {
        var movDir = new Vector3(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"), 0);
        if (movDir.x != 0.0f || movDir.y != 0.0f)
            Move(movDir);
        else
            StopMovement();
    }
}
