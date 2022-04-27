using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;

public class RPGInteractable : MonoBehaviour
{
    public RPGAction[] actions;

    void OnValidate()
    {
        foreach (var action in actions) action.setVariableTable.Refresh();
    }

    public void DoInteraction()
    {
        Helpers.ResolveRPGActions(actions);
    }
}
