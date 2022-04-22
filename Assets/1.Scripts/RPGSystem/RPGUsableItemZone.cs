using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class RPGUsableItemZone : MonoBehaviour
{
    public string requiredItemName;
    public UnityEvent onUsed;

    public void UsedItem(Item ustedItem)
    {
        if (requiredItemName == ustedItem.name) onUsed.Invoke();
    }

}
