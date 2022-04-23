using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;

public class RPGInteractable : MonoBehaviour
{
    public ConditionTable setOnInteraction;
    [Space(25)]
    public UnityEvent onInteractionEvent;
    public AudioClip onInteractionSound;

    void OnValidate()
    {
        setOnInteraction.Refresh();
    }

    public void DoInteraction()
    {
        if (onInteractionSound != null)
        {
            AudioManager.PlaySoundFromGameobject(onInteractionSound, gameObject);
        }
        foreach (var sw in setOnInteraction.switchTable) GameManager.SetSwitch(sw.ID(), sw.value);
        foreach (var va in setOnInteraction.variableTable)
        {
            switch (va.conditionality)
            {
                case VariableConditionality.Equals: GameManager.SetVariable(va.ID(), va.value); break;
                case VariableConditionality.GreaterThan: GameManager.AddToVariable(va.ID(), va.value); break;
                case VariableConditionality.LessThan: GameManager.AddToVariable(va.ID(), -va.value); break;
            }
        }
        onInteractionEvent.Invoke();
    }
}
