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

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player")) onEnter.Invoke();
    }

}
