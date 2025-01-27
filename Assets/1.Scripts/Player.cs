using RPGSystem;
using UnityEngine;

public class Player : Entity
{
    public LayerMask interactionLayerMask;

    void Update()
    {
        if (Application.isEditor)
        {
            if (Input.GetKeyDown(KeyCode.LeftControl)) collider2D.enabled = false;
            if (Input.GetKeyUp(KeyCode.LeftControl)) collider2D.enabled = true;
        }
        if (Input.GetButtonDown("Interact") && RPGManager.IsInteractionAvailable) CastInteraction(interactionLayerMask);
        if (Input.GetKeyDown(KeyCode.Space)) Run();
        if (Input.GetKeyUp(KeyCode.Space)) RunStop();
    }

    void FixedUpdate()
    {
        if (RPGManager.IsMovementAvailable) MovementControl();
    }

    void MovementControl()
    {
        var movDir = new Vector3(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"), 0);
        if (movDir.x != 0.0f || movDir.y != 0.0f)
            Move(movDir);
        else
            StopMovement().Forget();
    }

}
