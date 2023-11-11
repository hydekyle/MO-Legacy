using System.Collections.Generic;
using RPGSystem;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Serialization;

public class RPGEnabledByConditions : MonoBehaviour
{
    [GUIColor(0, 1, 1)]
    public VariableTableCondition conditionTable = new();
    [Space(25)]
    [FormerlySerializedAs("onEnableSound")]
    public AudioClip onEnabledSound;
    // Cache subscribed ones to avoid multiples subscriptions
    List<int> _subscribedSwitchID = new();
    List<int> _subscribedVariableID = new();
    List<int> _subscribedLocalVariableList = new();

    void OnValidate()
    {
        conditionTable.Refresh();
    }

    void Start()
    {
        SubscribeToRequiredValueConditions();
        SetActiveIfAllConditionsOK();
    }

    void OnDestroy()
    {
        UnSubscribeToRequiredConditions();
    }

    // Called every time a required switch or variable changes the value
    void SetActiveIfAllConditionsOK()
    {
        var isAllOK = conditionTable.IsAllConditionOK();
        if (isAllOK == gameObject.activeSelf) return;
        //if (onEnabledSound && !gameObject.activeSelf && isAllOK) AudioManager.PlaySoundFromGameobject(onEnabledSound, gameObject);
        gameObject.SetActive(isAllOK);
    }

    void SubscribeToRequiredValueConditions()
    {
        conditionTable.SubscribeToConditionTable(ref _subscribedSwitchID, ref _subscribedVariableID, ref _subscribedLocalVariableList, SetActiveIfAllConditionsOK);
    }

    void UnSubscribeToRequiredConditions()
    {
        conditionTable.UnsubscribeConditionTable(ref _subscribedSwitchID, ref _subscribedVariableID, ref _subscribedLocalVariableList, SetActiveIfAllConditionsOK);
    }

}
