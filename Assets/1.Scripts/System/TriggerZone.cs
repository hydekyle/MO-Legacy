using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;
using UnityObservables;

[ExecuteAlways]
public class TriggerZone : MonoBehaviour
{
    public TriggerType triggerType;
    [ShowIf("triggerType", TriggerType.other)]
    public GameObject other;
    [Space(10)]
    public UnityEvent onEnter;

    void OnTriggerEnter2D(Collider2D col)
    {
        switch (triggerType)
        {
            case TriggerType.player: PlayerEnter(col.gameObject); break;
            case TriggerType.other: OtherEnter(col.gameObject); break;
        }
    }

    void PlayerEnter(GameObject other)
    {
        if (other.CompareTag("Player")) onEnter.Invoke();
    }

    void OtherEnter(GameObject other)
    {
        if (this.other == other) onEnter.Invoke();
    }

}
