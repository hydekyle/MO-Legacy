using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;


namespace RPGSystem
{
    [Serializable]
    public class UISwitch
    {
        [TableColumnWidth(120)]
        [ValueDropdown("ReadSwitches", IsUniqueList = true, DropdownTitle = "Select Switch", DropdownHeight = 400)]
        public string switchID;
        [TableColumnWidth(120)]
        public bool value = true;
        [TableColumnWidth(20)]
#if UNITY_EDITOR
        [Button("Rename")]
        void Edit()
        {
            PopupWindow.Show(new Rect(), new UIPopupEditableVariableName(switchID, false));
        }
#endif

        public int ID()
        {
            return int.Parse(switchID.Substring(0, 4));
        }

        IEnumerable<string> ReadSwitches()
        {
            var dataLines = File.ReadAllLines(Constants.switchesData);

            foreach (var line in dataLines)
            {
                yield return line;
            }
        }

    }

    [Serializable]
    public class UIVariableCondition
    {
        [TableColumnWidth(140)]
        [ValueDropdown("ReadVariables", IsUniqueList = true, DropdownTitle = "Select Variable")]
        public string variableID;
        [ShowIf("variableID")]
        public Conditionality conditionality;
        [ShowIf("variableID")]
        public int value;
        [TableColumnWidth(20)]
#if UNITY_EDITOR
        [Button("Rename")]
        void Edit()
        {
            PopupWindow.Show(new Rect(), new UIPopupEditableVariableName(variableID, true));
        }
#endif

        public int ID()
        {
            return int.Parse(variableID[..4]);
        }

        IEnumerable ReadVariables()
        {
            var dataLines = File.ReadAllLines(Constants.variablesData);

            foreach (var line in dataLines)
            {
                yield return line;
            }
        }
    }

    [Serializable]
    public class UIVariableSet
    {
        [TableColumnWidth(140)]
        [ValueDropdown("ReadVariables", IsUniqueList = true, DropdownTitle = "Select Variable")]
        public string variableID;
        [ShowIf("variableID")]
        public VariableSetType setType;
        [ShowIf("variableID")]
        public int value;
        [ShowIf("@setType == VariableSetType.Random")]
        public int max;
        [TableColumnWidth(20)]
#if UNITY_EDITOR
        [Button("Rename")]
        void Edit()
        {
            PopupWindow.Show(new Rect(), new UIPopupEditableVariableName(variableID, true));
        }
#endif

        public int ID()
        {
            return int.Parse(variableID[..4]);
        }

        IEnumerable ReadVariables()
        {
            var dataLines = File.ReadAllLines(Constants.variablesData);

            foreach (var line in dataLines)
            {
                yield return line;
            }
        }
    }

    [Serializable]
    public class UILocalVariableCondition
    {
        int? _id;
        [HorizontalGroup("target")]
        [TableColumnWidth(90)]
        [HideLabel]
        public GameObject target;
        [TableColumnWidth(30)]
        public int value;
#if UNITY_EDITOR
        [VerticalGroup("target/btn")]
        [TableColumnWidth(90)]
        [Button("Self")]
        public void SaveID()
        {
            target = Selection.activeGameObject;
            if (target.TryGetComponent<UniqueIdentifier>(out var uniqueIdentifier))
            {
                _id = uniqueIdentifier.ID;
            }
            else
            {
                var newUniqueIdentifier = target.AddComponent<UniqueIdentifier>();
                _id = newUniqueIdentifier.ID;
            }
        }
#endif

        [HideLabel]
        public Conditionality conditionality;

        public int ID()
        {
            try
            {
                _id ??= target.GetComponent<UniqueIdentifier>().ID;
                return _id.Value;
            }
            catch
            {
                throw new Exception("RPG Error: Using RPG local variable for GameObject without UniqueIdentifier component detected. Did you remove it? You can fix it adding it manually");
            }
        }

    }

    [Serializable]
    public class UILocalVariableSet
    {
        int? _id;
        [HorizontalGroup("target")]
        [TableColumnWidth(90)]
        [HideLabel]
        public GameObject target;
        [HideLabel]
        public VariableSetType setType;
        [TableColumnWidth(30)]
        public int value;
        [ShowIf("@setType == VariableSetType.Random")]
        public int max;
        [VerticalGroup("target/btn")]
        [TableColumnWidth(90)]
        [Button("Self")]

#if UNITY_EDITOR
        public void SaveID()
        {
            target = Selection.activeGameObject;
            if (target.TryGetComponent<UniqueIdentifier>(out var uniqueIdentifier))
            {
                _id = uniqueIdentifier.ID;
            }
            else
            {
                var newUniqueIdentifier = target.AddComponent<UniqueIdentifier>();
                _id = newUniqueIdentifier.ID;
            }
        }
#endif


        public int ID()
        {
            try
            {
                _id ??= target.GetComponent<UniqueIdentifier>().ID;
                return _id.Value;
            }
            catch
            {
                throw new Exception("RPG Error: Using RPG local variable for GameObject without UniqueIdentifier component detected. Did you remove it? You can fix it adding it manually");
            }
        }

    }

#if UNITY_EDITOR
    public class UIPopupEditableVariableName : PopupWindowContent
    {
        string inputText = "";
        string editingName = "";
        int ID;
        public static UIPopupEditableVariableName Instance;
        bool isVariable;

        public UIPopupEditableVariableName(string varID, bool isVariable)
        {
            ID = int.Parse(varID[..4]);
            editingName = inputText = varID[4..]; ;
            this.isVariable = isVariable;
        }

        public override Vector2 GetWindowSize()
        {
            return new Vector2(200, 80);
        }

        public override void OnGUI(Rect rect)
        {
            var title = string.Format("Renaming '{0}'", editingName);
            GUILayout.Label(title, EditorStyles.boldLabel);
            inputText = GUILayout.TextField(inputText);

            Event e = Event.current;
            switch (e.type)
            {
                case EventType.KeyDown:
                    if (Event.current.keyCode == (KeyCode.Return)) Save(); break;
            }

            if (GUILayout.Button("SAVE")) Save();
        }

        void Save()
        {
            SaveNewSwitch(ID, inputText, isVariable);
#if UNITY_EDITOR
            if (Selection.activeGameObject.TryGetComponent<RPGEvent>(out var e))
                foreach (var page in e.pages)
                {
                    page.conditions.Refresh();
                    foreach (var action in page.actionList)
                    {
                        var actionType = action.GetType();
                        if (actionType == typeof(AddVariables))
                        {
                            AddVariables sv = (AddVariables)action;
                            sv.setVariables?.Refresh();
                        }
                        else if (actionType == typeof(CheckConditions))
                        {
                            CheckConditions sv = (CheckConditions)action;
                            sv.conditionList?.Refresh();
                        }
                    }
                }
#endif

            editorWindow.Close();
        }

        void SaveNewSwitch(int ID, string newName, bool isVariable)
        {
            var path = Application.dataPath;
            path += isVariable ? Constants.variablesData : Constants.switchesData;
            var dataLines = File.ReadAllLines(path);
            var textID = "";
            if (ID < 10) textID = "00" + ID;
            else if (ID < 100) textID = "0" + ID;
            dataLines[ID] = textID + " " + newName;
            File.WriteAllLines(path, dataLines);
        }

        IEnumerable<string> ReadSwitches()
        {
            var dataLines = File.ReadAllLines(Constants.switchesData);

            foreach (var line in dataLines)
            {
                yield return line;
            }
        }

        public override void OnOpen() { }

        public override void OnClose() { }
    }
#endif
}