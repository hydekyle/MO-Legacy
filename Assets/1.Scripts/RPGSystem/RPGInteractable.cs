using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;

public class RPGInteractable : MonoBehaviour
{
    public ConditionTable setOnInteraction;
    public UnityEvent onInteractionEvent;
    public AudioClip playSound;
    List<SwitchCondition> setSwitchList = new List<SwitchCondition>();
    List<VariableCondition> setVariableList = new List<VariableCondition>();

    void OnValidate()
    {
        setOnInteraction.Refresh();
    }

    void Awake()
    {
        LoadTableData();
    }

    void LoadTableData()
    {
        foreach (var tableItem in setOnInteraction.switchTable)
        {
            setSwitchList.Add(new SwitchCondition()
            {
                name = tableItem.switchID,
                value = tableItem.value
            });
        }
        foreach (var tableItem in setOnInteraction.variableTable)
        {
            setVariableList.Add(new VariableCondition()
            {
                name = tableItem.variableID,
                value = tableItem.value,
                conditionality = tableItem.condition
            });
        }
    }

    public void DoInteraction()
    {
        if (playSound != null)
        {
            AudioManager.PlaySoundFromGameobject(playSound, gameObject);
        }
        foreach (var sw in setSwitchList) GameManager.SetSwitch(sw.ID(), sw.value);
        foreach (var va in setVariableList)
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
