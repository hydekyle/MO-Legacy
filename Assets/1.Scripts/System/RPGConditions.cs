using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityObservables;

public class RPGConditions : MonoBehaviour
{
    public Switch[] requiredSwitchList;
    public Variable[] requiredVariableList;

    void Start()
    {
        SubscribeToRequiredConditions();
        SetActiveIfAllConditionsOK();
    }

    void SetActiveIfAllConditionsOK()
    {
        gameObject.SetActive(isAllConditionsOK());
    }

    // Called every time a required switch or variable changes the value
    void OnRequiredConditionValueChanged()
    {
        SetActiveIfAllConditionsOK();
    }

    void SubscribeToRequiredConditions()
    {
        foreach (var s in requiredSwitchList)
        {
            if (!GameManager.Instance.gameData.switches.ContainsKey(s.ID))
            {
                GameManager.SetSwitch(s.ID, false);
            }
            GameManager.Instance.gameData.switches[s.ID].OnChanged += OnRequiredConditionValueChanged;
        }
        foreach (var v in requiredVariableList)
        {
            if (!GameManager.Instance.gameData.variables.ContainsKey(v.ID))
            {
                GameManager.SetVariable(v.ID, 0);
            }
            GameManager.Instance.gameData.variables[v.ID].OnChanged += OnRequiredConditionValueChanged;
        }
    }

    void UnSubscribeToRequiredConditions()
    {
        foreach (var s in requiredSwitchList)
        {
            GameManager.Instance.gameData.switches[s.ID].OnChanged -= OnRequiredConditionValueChanged;
        }
        foreach (var v in requiredVariableList)
        {
            GameManager.Instance.gameData.variables[v.ID].OnChanged -= OnRequiredConditionValueChanged;
        }
    }

    bool isAllConditionsOK()
    {
        for (var x = 0; x < requiredSwitchList.Length; x++)
        {
            var switchValue = GameManager.GetSwitch(requiredSwitchList[x].ID);
            if (requiredSwitchList[x].value != switchValue) return false;
        }
        for (var x = 0; x < requiredVariableList.Length; x++)
        {
            var variableValue = GameManager.GetVariable(requiredVariableList[x].ID);
            if (requiredVariableList[x].value != variableValue) return false;
        }
        return true;
    }
}
