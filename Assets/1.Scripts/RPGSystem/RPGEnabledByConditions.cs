using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

public class RPGEnabledByConditions : MonoBehaviour
{
    public RPGConditionTable conditionTable;
    [Tooltip("Añade una segunda tabla que funciona como OR")]
    public bool enableTableOR;
    [ShowIf("enableTableOR")]
    public RPGConditionTable conditionTableOR;
    [Space(25)]
    [FormerlySerializedAs("onEnableSound")]
    public AudioClip onEnabledSound;
    // Cache subscribed ones to avoid multiples subscriptions
    List<int> _subscribedSwitchID = new List<int>();
    List<int> _subscribedVariableID = new List<int>();

    void OnValidate()
    {
        conditionTable.Refresh();
    }

    void Start()
    {
        SubscribeToRequiredValueConditions();
        SetActiveIfAllConditionsOK();
    }

    private void OnDestroy()
    {
        UnSubscribeToRequiredConditions();
    }

    // Called every time a required switch or variable changes the value
    void SetActiveIfAllConditionsOK()
    {
        var isAllOK = IsAllConditionsOK();
        if (isAllOK == gameObject.activeSelf) return;
        if (onEnabledSound && !gameObject.activeSelf && isAllOK) AudioManager.PlaySoundFromGameobject(onEnabledSound, gameObject);
        gameObject.SetActive(isAllOK);
    }

    void SubscribeToRequiredValueConditions()
    {
        SubscribeConditionTable(conditionTable);
        if (enableTableOR) SubscribeConditionTable(conditionTableOR);
    }

    void SubscribeConditionTable(RPGConditionTable cTable)
    {
        foreach (var s in cTable.switchTable)
        {
            var ID = s.ID();
            if (_subscribedSwitchID.Contains(ID)) continue; // Avoiding resubscription
            GameManager.SubscribeToSwitchChangedEvent(ID, SetActiveIfAllConditionsOK);
            _subscribedSwitchID.Add(ID);
        }
        foreach (var v in cTable.variableTable)
        {
            var ID = v.ID();
            if (_subscribedVariableID.Contains(ID)) continue;
            GameManager.SubscribeToVariableChangedEvent(ID, SetActiveIfAllConditionsOK);
            _subscribedVariableID.Add(ID);
        }
    }

    void UnSubscribeToRequiredConditions()
    {
        UnsubscribeConditionTable(conditionTable);
        if (enableTableOR) UnsubscribeConditionTable(conditionTableOR);
    }

    void UnsubscribeConditionTable(RPGConditionTable cTable)
    {
        foreach (var id in _subscribedSwitchID) GameManager.UnsubscribeToSwitchChangedEvent(id, SetActiveIfAllConditionsOK);
        foreach (var id in _subscribedVariableID) GameManager.UnsubscribeToVariableChangedEvent(id, SetActiveIfAllConditionsOK);
        _subscribedSwitchID.Clear();
        _subscribedVariableID.Clear();
    }

    bool IsAllConditionsOK()
    {
        if (enableTableOR) return IsTableConditionsOK(conditionTable) || IsTableConditionsOK(conditionTableOR);
        else return IsTableConditionsOK(conditionTable);
    }

    bool IsTableConditionsOK(RPGConditionTable cTable)
    {
        foreach (var requiredSwitch in cTable.switchTable)
        {
            var switchValue = GameManager.GetSwitch(requiredSwitch.ID());
            if (requiredSwitch.value != switchValue) return false;
        }
        foreach (var requiredVariable in cTable.variableTable)
        {
            var variableValue = GameManager.GetVariable(requiredVariable.ID());
            switch (requiredVariable.conditionality)
            {
                case VariableConditionality.Equals: if (requiredVariable.value == variableValue) continue; break;
                case VariableConditionality.GreaterThan: if (requiredVariable.value < variableValue) continue; break;
                case VariableConditionality.LessThan: if (requiredVariable.value > variableValue) continue; break;
            }
            return false;
        }
        return true;
    }
}
