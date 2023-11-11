using System;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

namespace RPGSystem
{
    [Serializable]
    public class VariableTableSet
    {
        [TableList]
        public List<UISwitch> switchTable = new();
        [Space]
        [TableList]
        public List<UIVariableSet> setVariableTable = new();
        [Space]
        [TableList]
        public List<UILocalVariableSet> setLocalVariableTable = new();

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

            if (setVariableTable.Count > 0)
            {
                var variableLineList = new List<string>();
                foreach (var line in RPGFileManager.UIReadVariablesFromTXT())
                {
                    variableLineList.Add(line);
                }
                foreach (var vr in setVariableTable)
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

    }
}
