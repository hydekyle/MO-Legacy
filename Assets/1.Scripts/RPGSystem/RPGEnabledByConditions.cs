using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

public class RPGEnabledByConditions : MonoBehaviour
{
    public ConditionTable conditions;
    [Space(25)]
    [Tooltip("Play a clip when all conditions are met")]
    public AudioClip playSound;
    List<SwitchCondition> requiredSwitchList = new List<SwitchCondition>();
    List<VariableCondition> requiredVariableList = new List<VariableCondition>();

    void OnValidate()
    {
        conditions.Refresh();
    }

    void Start()
    {
        LoadTableData();
        SubscribeToRequiredConditions();
        SetActiveIfAllConditionsOK();
    }

    private void OnDestroy()
    {
        UnSubscribeToRequiredConditions();
    }

    void LoadTableData()
    {
        foreach (var tableItem in conditions.switchTable)
        {
            requiredSwitchList.Add(new SwitchCondition()
            {
                name = tableItem.switchID,
                value = tableItem.value
            });
        }
        foreach (var tableItem in conditions.variableTable)
        {
            requiredVariableList.Add(new VariableCondition()
            {
                name = tableItem.variableID,
                value = tableItem.value,
                conditionality = tableItem.condition
            });
        }
    }

    // Called every time a required switch or variable changes the value
    void SetActiveIfAllConditionsOK()
    {
        var isAllOK = isAllConditionsOK();
        if (isAllOK == gameObject.activeSelf) return;
        if (playSound && !gameObject.activeSelf && isAllOK) AudioManager.PlaySoundFromGameobject(playSound, gameObject);
        gameObject.SetActive(isAllOK);
    }

    void SubscribeToRequiredConditions()
    {
        foreach (var s in requiredSwitchList)
        {
            if (!GameManager.Instance.gameData.switches.ContainsKey(s.ID()))
            {
                GameManager.SetSwitch(s.ID(), false);
            }
            GameManager.Instance.gameData.switches[s.ID()].OnChanged += SetActiveIfAllConditionsOK;
        }
        foreach (var v in requiredVariableList)
        {
            if (!GameManager.Instance.gameData.variables.ContainsKey(v.ID()))
            {
                GameManager.SetVariable(v.ID(), 0);
            }
            GameManager.Instance.gameData.variables[v.ID()].OnChanged += SetActiveIfAllConditionsOK;
        }
    }

    void UnSubscribeToRequiredConditions()
    {
        foreach (var requiredSwitch in requiredSwitchList)
        {
            GameManager.Instance.gameData.switches[requiredSwitch.ID()].OnChanged -= SetActiveIfAllConditionsOK;
        }
        foreach (var requiredVariable in requiredVariableList)
        {
            GameManager.Instance.gameData.variables[requiredVariable.ID()].OnChanged -= SetActiveIfAllConditionsOK;
        }
    }

    bool isAllConditionsOK()
    {
        foreach (var requiredSwitch in requiredSwitchList)
        {
            var switchValue = GameManager.GetSwitch(requiredSwitch.ID());
            if (requiredSwitch.value != switchValue) return false;
        }
        foreach (var requiredVariable in requiredVariableList)
        {
            var variableValue = GameManager.GetVariable(requiredVariable.ID());
            switch (requiredVariable.conditionality)
            {
                case VariableConditionality.Equals: if (requiredVariable.value == variableValue) return true; break;
                case VariableConditionality.GreaterThan: if (requiredVariable.value < variableValue) return true; break;
                case VariableConditionality.LessThan: if (requiredVariable.value > variableValue) return true; break;
            }
            return false;
        }
        return true;
    }
}
