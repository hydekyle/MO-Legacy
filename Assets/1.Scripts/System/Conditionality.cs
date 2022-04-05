using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityObservables;

public class Conditionality : MonoBehaviour
{
    public Switch[] requiredSwitchList;
    public Variable[] requiredVariableList;

    void OnEnable()
    {
        SubscribeToGameDataChanges();
    }

    void OnDisable()
    {
        UnsubscribeToGameDataChanges();
    }

    void OnChangedValues()
    {
        transform.GetChild(0).gameObject.SetActive(isAllConditionsOK());
    }

    void SubscribeToGameDataChanges()
    {
        if (requiredSwitchList.Length > 0 || requiredVariableList.Length > 0)
        {
            GameManager.Instance.onGameDataChanged.AddListener(OnChangedValues);
        }
    }

    void UnsubscribeToGameDataChanges()
    {
        GameManager.Instance.onGameDataChanged.RemoveListener(OnChangedValues);
    }

    bool isAllConditionsOK()
    {
        for (var x = 0; x < requiredSwitchList.Length; x++)
        {
            var switchValue = GameManager.Instance.GetSwitch(requiredSwitchList[x].ID);
            if (requiredSwitchList[x].value != switchValue) return false;
        }
        for (var x = 0; x < requiredVariableList.Length; x++)
        {
            var variableValue = GameManager.Instance.GetVariable(requiredVariableList[x].ID);
            if (requiredVariableList[x].value != variableValue) return false;
        }
        return true;
    }
}
