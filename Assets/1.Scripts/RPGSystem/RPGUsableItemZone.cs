using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;

public class RPGUsableItemZone : MonoBehaviour
{
    public string requiredItemName;
    public UnityEvent onUsed;
    public List<RPGAction> actions;

    public void UsedItem(ScriptableItem ustedItem)
    {
        if (requiredItemName == ustedItem.name) onUsed.Invoke();
    }

}
