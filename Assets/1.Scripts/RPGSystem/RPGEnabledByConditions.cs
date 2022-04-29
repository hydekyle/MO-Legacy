using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

public class RPGEnabledByConditions : MonoBehaviour
{
    [GUIColor(0, 1, 1)]
    public RPGVariableTable conditionTable;
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
    }

    void SubscribeConditionTable(RPGVariableTable cTable)
    {
        foreach (var s in cTable.switchTable)
        {
            var ID = s.ID();
            if (_subscribedSwitchID.Contains(ID)) continue; // Avoiding resubscription
            GameData.SubscribeToSwitchChangedEvent(ID, SetActiveIfAllConditionsOK);
            _subscribedSwitchID.Add(ID);
        }
        foreach (var v in cTable.variableTable)
        {
            var ID = v.ID();
            if (_subscribedVariableID.Contains(ID)) continue;
            GameData.SubscribeToVariableChangedEvent(ID, SetActiveIfAllConditionsOK);
            _subscribedVariableID.Add(ID);
        }
    }

    void UnSubscribeToRequiredConditions()
    {
        UnsubscribeConditionTable(conditionTable);
    }

    void UnsubscribeConditionTable(RPGVariableTable cTable)
    {
        foreach (var id in _subscribedSwitchID) GameData.UnsubscribeToSwitchChangedEvent(id, SetActiveIfAllConditionsOK);
        foreach (var id in _subscribedVariableID) GameData.UnsubscribeToVariableChangedEvent(id, SetActiveIfAllConditionsOK);
        _subscribedSwitchID.Clear();
        _subscribedVariableID.Clear();
    }

    bool IsAllConditionsOK()
    {
        return IsTableConditionsOK(conditionTable);
    }

    bool IsTableConditionsOK(RPGVariableTable cTable)
    {
        foreach (var requiredSwitch in cTable.switchTable)
        {
            var switchValue = GameData.GetSwitch(requiredSwitch.ID());
            if (requiredSwitch.value != switchValue) return false;
        }
        foreach (var requiredVariable in cTable.variableTable)
        {
            var variableValue = GameData.GetVariable(requiredVariable.ID());
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
