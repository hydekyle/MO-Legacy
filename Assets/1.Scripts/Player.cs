using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : Entity
{
    void Update()
    {
        var movDir = new Vector3(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"), 0);
        Move(movDir);
    }
}
