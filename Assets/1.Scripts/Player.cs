using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : Entity
{
    void Update()
    {
        if (GameManager.isMovementAvailable) MovementControl();
        if (Input.GetButtonDown("Interact") && GameManager.isInteractAvailable) CastInteraction();
    }

    private void MovementControl()
    {
        var movDir = new Vector3(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"), 0);
        if (movDir.x != 0.0f || movDir.y != 0.0f)
            Move(movDir);
        else
            StopMovement();
    }
}
