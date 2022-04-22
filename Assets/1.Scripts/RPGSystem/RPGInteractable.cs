using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;

public class RPGInteractable : MonoBehaviour
{
    [TableList]
    [GUIColor(0, 1, 0)]
    public List<TableViewSwitch> switchTable = new List<TableViewSwitch>();
    [Space]
    [TableList]
    [GUIColor(0, 0.9f, 0)]
    public List<TableViewVariable> variableTable = new List<TableViewVariable>();
    [Space(25)]
    public AudioClip playSound;
    public UnityEvent onInteractionEvent;
    List<SwitchCondition> setSwitchList = new List<SwitchCondition>();
    List<VariableCondition> setVariableList = new List<VariableCondition>();

    void Awake()
    {
        LoadTableData();
    }

    void LoadTableData()
    {
        foreach (var tableItem in switchTable)
        {
            setSwitchList.Add(new SwitchCondition()
            {
                ID = tableItem.switchID,
                value = tableItem.value
            });
        }
        foreach (var tableItem in variableTable)
        {
            setVariableList.Add(new VariableCondition()
            {
                ID = tableItem.variableID,
                value = tableItem.value
            });
        }
    }

    public void DoInteraction()
    {
        if (playSound != null)
        {
            AudioManager.PlaySoundFromGameobject(playSound, gameObject);
        }
        foreach (var sw in setSwitchList) GameManager.SetSwitch(sw.ID, sw.value);
        foreach (var va in setVariableList) GameManager.SetVariable(va.ID, va.value);
        onInteractionEvent.Invoke();
    }
}
