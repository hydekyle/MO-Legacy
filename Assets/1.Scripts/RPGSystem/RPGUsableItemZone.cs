using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;

public enum ActionType { SetSwitch, SetVariable, Talk }

[Serializable]
public class RPGAction
{
    public ActionType actionType;
    [ShowIf("actionType", ActionType.SetSwitch)]
    public ConditionTable switches;
    [ShowIf("actionType", ActionType.Talk)]
    public string msg;
}

public class RPGUsableItemZone : MonoBehaviour
{
    public string requiredItemName;
    public UnityEvent onUsed;
    public List<RPGAction> actions;


    public void UsedItem(Item ustedItem)
    {
        if (requiredItemName == ustedItem.name) onUsed.Invoke();
    }

}
