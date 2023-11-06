using System;
using System.Collections;
using System.Collections.Generic;
using RPGSystem;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;
using RPGSystem;

public class RPGUsableItemZone : MonoBehaviour
{
    public string requiredItemName;
    public UnityEvent onUsed;
    // [SerializeReference]
    // public List<RPGAction> actions;

    public void UsedItem(ScriptableItem ustedItem)
    {
        if (requiredItemName == ustedItem.name) onUsed.Invoke();
    }

}
