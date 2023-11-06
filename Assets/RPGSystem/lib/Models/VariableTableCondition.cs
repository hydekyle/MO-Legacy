using System;
using System.Collections.Generic;
using System.IO;
using Sirenix.OdinInspector;
using UnityEngine;

namespace RPGSystem
{
    [Serializable]
    public class VariableTableCondition
    {
        [TableList]
        public List<UISwitch> switchTable = new();
        [Space]
        [TableList]
        public List<UIVariableCondition> variableTable = new();
        [Space]
        [TableList]
        public List<UILocalVariableCondition> localVariableTable = new();

        /// <summary>Refresh variable names if they have changed in .txt</summary>
        public void Refresh()
        {
            if (switchTable.Count > 0)
            {
                var switchLineList = new List<string>();
                foreach (var line in RPGFileManager.UIReadSwitchesFromTXT())
                {
                    switchLineList.Add(line);
                }
                foreach (var sw in switchTable)
                {
                    if (sw.switchID == null || sw.switchID == "") return;
                    var ID = sw.switchID[..4];
                    var txtID = switchLineList[int.Parse(ID)];
                    if (txtID != sw.switchID)
                    {
                        sw.switchID = txtID;
                    }
                }
            }

            if (variableTable.Count > 0)
            {
                var variableLineList = new List<string>();
                foreach (var line in RPGFileManager.UIReadVariablesFromTXT())
                {
                    variableLineList.Add(line);
                }
                foreach (var vr in variableTable)
                {
                    if (vr.variableID == null) return;
                    var ID = vr.variableID[..4];
                    var txtID = variableLineList[int.Parse(ID)];
                    if (txtID != vr.variableID)
                    {
                        vr.variableID = txtID;
                    }
                }
            }
        }

        public void SubscribeToConditionTable(ref List<int> _subscribedSwitchList, ref List<int> _subscribedVariableList, ref List<int> _subscribedLocalVariableList, Action action)
        {
            foreach (var s in switchTable)
            {
                var ID = s.ID();
                if (_subscribedSwitchList.Contains(ID)) continue; // Avoiding resubscription
                RPGManager.Instance.gameData.SubscribeToSwitchChangedEvent(ID, action);
                _subscribedSwitchList.Add(ID);
            }
            foreach (var v in variableTable)
            {
                var ID = v.ID();
                if (_subscribedVariableList.Contains(ID)) continue;
                RPGManager.Instance.gameData.SubscribeToVariableChangedEvent(ID, action);
                _subscribedVariableList.Add(ID);
            }
            foreach (var lv in localVariableTable)
            {
                var ID = lv.ID();
                if (!_subscribedLocalVariableList.Contains(ID))
                {
                    _subscribedLocalVariableList.Add(ID);
                    RPGManager.Instance.gameData.SubscribeToLocalVariableChangedEvent(ID, action);
                }
            }
        }

        public void UnsubscribeConditionTable(ref List<int> _subscribedSwitchList, ref List<int> _subscribedVariableList, ref List<int> _subscribedLocalVariableList, Action action)
        {
            foreach (var id in _subscribedLocalVariableList) RPGManager.Instance.gameData.UnsubscribeToLocalVariableChangedEvent(id, action);
            foreach (var id in _subscribedSwitchList) RPGManager.Instance.gameData.UnsubscribeToSwitchChangedEvent(id, action);
            foreach (var id in _subscribedVariableList) RPGManager.Instance.gameData.UnsubscribeToVariableChangedEvent(id, action);
            _subscribedSwitchList.Clear();
            _subscribedVariableList.Clear();
        }

        public bool IsAllConditionOK()
        {
            foreach (var requiredLocalVariable in localVariableTable)
            {
                var variableValue = RPGManager.Instance.gameData.GetLocalVariable(requiredLocalVariable.ID());
                switch (requiredLocalVariable.conditionality)
                {
                    case Conditionality.Equals: if (requiredLocalVariable.value == variableValue) continue; break;
                    case Conditionality.GreaterThan: if (requiredLocalVariable.value > variableValue) continue; break;
                    case Conditionality.LessThan: if (requiredLocalVariable.value < variableValue) continue; break;
                }
                return false;
            }
            foreach (var requiredSwitch in switchTable)
            {
                var switchValue = RPGManager.Instance.gameData.GetSwitch(requiredSwitch.ID());
                if (requiredSwitch.value != switchValue) return false;
            }
            foreach (var requiredVariable in variableTable)
            {
                var variableValue = RPGManager.Instance.gameData.GetVariable(requiredVariable.ID());
                switch (requiredVariable.conditionality)
                {
                    case Conditionality.Equals: if (requiredVariable.value == variableValue) continue; break;
                    case Conditionality.GreaterThan: if (requiredVariable.value < variableValue) continue; break;
                    case Conditionality.LessThan: if (requiredVariable.value > variableValue) continue; break;
                }
                return false;
            }
            return true;
        }
    }
}
