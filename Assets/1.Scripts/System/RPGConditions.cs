using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

public class RPGConditions : MonoBehaviour
{
    public SwitchCondition[] requiredSwitchList;
    public VariableCondition[] requiredVariableList;
    public AudioClip onEnabledAudio;

    void Start()
    {
        SubscribeToRequiredConditions();
        SetActiveIfAllConditionsOK();
    }

    private void OnDestroy()
    {
        UnSubscribeToRequiredConditions();
    }

    // Called every time a required switch or variable changes the value
    void SetActiveIfAllConditionsOK()
    {
        var isAllOK = isAllConditionsOK();
        if (isAllOK == gameObject.activeSelf) return;
        if (onEnabledAudio && !gameObject.activeSelf && isAllOK) AudioManager.PlaySoundFromGameobject(onEnabledAudio, gameObject);
        gameObject.SetActive(isAllOK);
    }

    void SubscribeToRequiredConditions()
    {
        foreach (var s in requiredSwitchList)
        {
            if (!GameManager.Instance.gameData.switches.ContainsKey(s.ID))
            {
                GameManager.SetSwitch(s.ID, false);
            }
            GameManager.Instance.gameData.switches[s.ID].OnChanged += SetActiveIfAllConditionsOK;
        }
        foreach (var v in requiredVariableList)
        {
            if (!GameManager.Instance.gameData.variables.ContainsKey(v.ID))
            {
                GameManager.SetVariable(v.ID, 0);
            }
            GameManager.Instance.gameData.variables[v.ID].OnChanged += SetActiveIfAllConditionsOK;
        }
    }

    void UnSubscribeToRequiredConditions()
    {
        foreach (var requiredSwitch in requiredSwitchList)
        {
            GameManager.Instance.gameData.switches[requiredSwitch.ID].OnChanged -= SetActiveIfAllConditionsOK;
        }
        foreach (var requiredVariable in requiredVariableList)
        {
            GameManager.Instance.gameData.variables[requiredVariable.ID].OnChanged -= SetActiveIfAllConditionsOK;
        }
    }

    bool isAllConditionsOK()
    {
        foreach (var requiredSwitch in requiredSwitchList)
        {
            var switchValue = GameManager.GetSwitch(requiredSwitch.ID);
            if (requiredSwitch.value != switchValue) return false;
        }
        foreach (var requiredVariable in requiredVariableList)
        {
            var variableValue = GameManager.GetVariable(requiredVariable.ID);
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
