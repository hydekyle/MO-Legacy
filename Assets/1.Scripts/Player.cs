using RPGSystem;
using UnityEngine;

public class Player : Entity
{
    void OnValidate()
    {
        CheckSpriteOrderByPositionY();
    }

    void Update()
    {
        if (Application.isEditor)
        {
            if (Input.GetKeyDown(KeyCode.LeftControl)) boxCollider2D.enabled = false;
            if (Input.GetKeyUp(KeyCode.LeftControl)) boxCollider2D.enabled = true;
        }
        if (Input.GetButtonDown("Interact") && RPGManager.Instance.isInteractionAvailable) CastInteraction();
    }

    void FixedUpdate()
    {
        if (RPGManager.Instance.isMovementAvailable) MovementControl();
    }

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.TryGetComponent<RPGEvent>(out RPGEvent _event))
            _event.TouchPlayer();
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
