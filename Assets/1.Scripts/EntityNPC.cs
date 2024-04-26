using System.Collections;
using System.Collections.Generic;
using RPGSystem;
using UnityEngine;

public class EntityNPC : Entity, IInteractable
{
    public void InteractionFrom(Entity interactionEmmiter)
    {
        LookAtWorldPosition(interactionEmmiter.transform.position);
    }

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }
}
