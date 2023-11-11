using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using RPGSystem;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

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
        var path = Application.dataPath + "/Editor/switches.txt";
        var dataLines = File.ReadAllLines(path);

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
        return int.Parse(variableID.Substring(0, 4));
    }

    IEnumerable ReadVariables()
    {
        var path = Application.dataPath + "/Editor/variables.txt"; ;
        var dataLines = File.ReadAllLines(path);

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
        return int.Parse(variableID.Substring(0, 4));
    }

    IEnumerable ReadVariables()
    {
        var path = Application.dataPath + "/Editor/variables.txt"; ;
        var dataLines = File.ReadAllLines(path);

        foreach (var line in dataLines)
        {
            yield return line;
        }
    }
}

[Serializable]
public class UILocalVariableCondition
{
    [HorizontalGroup("target")]
    [TableColumnWidth(90)]
    [HideLabel]
    public GameObject target;
    [TableColumnWidth(30)]
    public int value;
    [VerticalGroup("target/btn")]
    [TableColumnWidth(90)]
    [Button("Self")]
    public void SaveID()
    {
        target = Selection.activeGameObject;
    }
    [HideLabel]
    public Conditionality conditionality;

    public int ID()
    {
        return String.Concat(target.name, SceneManager.GetActiveScene().name).GetHashCode();
    }

}

[Serializable]
public class UILocalVariableSet
{
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
    public void SaveID()
    {
        target = Selection.activeGameObject;
    }

    public int ID()
    {
        return String.Concat(target.name, SceneManager.GetActiveScene().name).GetHashCode();
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
        ID = int.Parse(varID.Substring(0, 4));
        editingName = inputText = varID.Substring(4, varID.Length - 4); ;
        this.isVariable = isVariable;
    }

    public override Vector2 GetWindowSize()
    {
        return new Vector2(200, 80);
    }

    public override void OnGUI(Rect rect)
    {
        var title = String.Format("Renaming '{0}'", editingName);
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
        if (Selection.activeGameObject.TryGetComponent<RPGEnabledByConditions>(out var c)) c.conditionTable.Refresh();
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
        editorWindow.Close();
    }

    void SaveNewSwitch(int ID, string newName, bool isVariable)
    {
        var path = Application.dataPath;
        path += isVariable ? "/Editor/variables.txt" : "/Editor/switches.txt";
        var dataLines = File.ReadAllLines(path);
        var textID = "";
        if (ID < 10) textID = "00" + ID;
        else if (ID < 100) textID = "0" + ID;
        dataLines[ID] = textID + " " + newName;
        File.WriteAllLines(path, dataLines);
    }

    IEnumerable<string> ReadSwitches()
    {
        var path = Application.dataPath + "/Editor/switches.txt";
        var dataLines = File.ReadAllLines(path);

        foreach (var line in dataLines)
        {
            yield return line;
        }
    }

    public override void OnOpen() { }

    public override void OnClose() { }
}
#endif