using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityObservables;

public class Conditionality : MonoBehaviour
{
    [Header("SWITCHES")]
    public Observable<string[]> requiredSwitchList = new Observable<string[]>();
    public List<bool> requiredSwitchStatus = new List<bool>();
    [Header("VARIABLES")]
    public Observable<string[]> requiredVariableList = new Observable<string[]>();
    public List<int> requiredVariableValue = new List<int>();

    void OnValidate()
    {
        requiredSwitchList.OnValidate();
        requiredVariableList.OnValidate();
        OnSwitchConditionChanged();
        OnVariableConditionChanged();
    }

    void OnEnable()
    {
        requiredSwitchList.OnChanged += OnSwitchConditionChanged;
        requiredVariableList.OnChanged += OnVariableConditionChanged;
        SubscribeToDataChanges();
    }

    void OnDisable()
    {
        UnsubscribeToSwitchAndVariablesChanges();
    }

    void OnChangedValues()
    {
        transform.GetChild(0).gameObject.SetActive(isAllConditionsOK());
    }

    void SubscribeToDataChanges()
    {
        if (requiredSwitchList.Value.Length > 0 || requiredVariableList.Value.Length > 0)
        {
            GameManager.Instance.onGameDataChanged.AddListener(OnChangedValues);
        }
    }

    void UnsubscribeToSwitchAndVariablesChanges()
    {
        GameManager.Instance.onGameDataChanged.RemoveListener(OnChangedValues);
    }

    void OnSwitchConditionChanged()
    {
        AddEditableSwitches();
    }

    void OnVariableConditionChanged()
    {
        AddEditableVariables();
    }

    // It adds editable values for each switch added as condition
    void AddEditableSwitches()
    {
        var newList = new List<bool>() { };
        for (var x = 0; x < requiredSwitchList.Value.Length; x++)
        {
            try
            {
                // Try to load previous value
                newList.Add(requiredSwitchStatus[x]);
            }
            catch
            {
                newList.Add(false);
            }
        }
        // Avoid reasign if lists are equals
        if (requiredSwitchStatus != newList) requiredSwitchStatus = newList;
    }

    void AddEditableVariables()
    {
        var newList = new List<int>();
        for (var x = 0; x < requiredVariableList.Value.Length; x++)
        {
            try
            {
                newList.Add(requiredVariableValue[x]);
            }
            catch
            {
                newList.Add(0);
            }
        }
        if (requiredVariableValue != newList) requiredVariableValue = newList;
    }

    bool isAllConditionsOK()
    {
        for (var x = 0; x < requiredSwitchStatus.Count; x++)
        {
            var switchStatus = GameManager.Instance.GetSwitch(requiredSwitchList.Value[x]);
            if (requiredSwitchStatus[x] != switchStatus) return false;
        }
        for (var x = 0; x < requiredVariableValue.Count; x++)
        {
            var variableStatus = GameManager.Instance.GetVariable(requiredVariableList.Value[x]);
            if (requiredVariableValue[x] != variableStatus) return false;
        }
        return true;
    }
}
