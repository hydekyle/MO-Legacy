using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityObservables;
using Sirenix.OdinInspector;
using Cysharp.Threading.Tasks;
using System.IO;
using UnityEditor;
using UnityEngine.Events;

public enum TriggerType { player, other, any }
public enum FaceDirection { North, West, East, South }
public enum VariableConditionality { Equals, GreaterThan, LessThan }

// 0 (down) walking
// 1 (down) idle
// 2 (down) walking
// 3 (left) walking
// 6 (right) walking
// 9 (up) walking

public class Entity : MonoBehaviour
{
    public Sprite[] spriteList;
    public float movementSpeed;
    public float animationFrameTime = 0.1f;
    [HideInInspector]
    public FaceDirection faceDirection;
    SpriteRenderer spriteRenderer;
    float _lastTimeAnimationChanged = -1;
    List<int> stepAnimOrder = new List<int>() { 0, 1, 2, 1 };
    int _indexStepAnim = 0;

    private void Awake()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
    }

    public void Interact()
    {
        GameManager.CastInteraction(transform.position);
    }

    public void Move(Vector3 moveDirection)
    {
        transform.position = Vector3.Lerp(transform.position, transform.position + new Vector3(moveDirection.x, moveDirection.y, 0), Time.deltaTime * movementSpeed);
        AnimationWalk(moveDirection);
    }

    public async void StopMovement()
    {
        await UniTask.WaitUntil(() => _lastTimeAnimationChanged + animationFrameTime < Time.time);
        try { LookAtDirection(faceDirection); } catch { }
    }

    void LookAtDirection(FaceDirection fDir)
    {
        switch (fDir)
        {
            case FaceDirection.South:
                spriteRenderer.sprite = spriteList[1];
                break;
            case FaceDirection.West:
                spriteRenderer.sprite = spriteList[4];
                break;
            case FaceDirection.East:
                spriteRenderer.sprite = spriteList[7];
                break;
            case FaceDirection.North:
                spriteRenderer.sprite = spriteList[10];
                break;
        }
        faceDirection = fDir;
    }

    public void AnimationWalk(Vector3 moveDirection)
    {
        switch (faceDirection)
        {
            case FaceDirection.South:
                spriteRenderer.sprite = spriteList[0 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.West:
                spriteRenderer.sprite = spriteList[3 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.East:
                spriteRenderer.sprite = spriteList[6 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.North:
                spriteRenderer.sprite = spriteList[9 + stepAnimOrder[_indexStepAnim]];
                break;
        }
        // Animation Steps
        if (Time.time > _lastTimeAnimationChanged + animationFrameTime)
        {
            _indexStepAnim = _indexStepAnim < stepAnimOrder.Count - 1 ? _indexStepAnim + 1 : 0;
            _lastTimeAnimationChanged = Time.time;
            var _faceDirection = Helpers.GetFaceDirectionByDir(moveDirection);
            faceDirection = _faceDirection;
        }
    }
}

[Serializable]
public struct Item
{
    [PreviewField(50, ObjectFieldAlignment.Right)]
    public Sprite sprite;
    public string name;
    public string description;
    public bool isUsable;
}

[Serializable]
public struct GameData
{
    public RPGSwitches switches;
    public RPGVariables variables;
    public List<Item> inventory;
}

[Serializable]
public class SwitchCondition
{
    public string name;
    public bool value;

    public int ID()
    {
        return int.Parse(name.Substring(0, 4));
    }
}

[Serializable]
public class VariableCondition
{
    public string name;
    public float value;
    public VariableConditionality conditionality;

    public int ID()
    {
        return int.Parse(name.Substring(0, 4));
    }
}

[Serializable]
public class RPGSwitches : UnitySerializedDictionary<int, Observable<bool>> { }

[Serializable]
public class RPGVariables : UnitySerializedDictionary<int, Observable<float>> { }

// This is required for Odin Inspector Plugin to serialize Dictionary
public abstract class UnitySerializedDictionary<TKey, TValue> : Dictionary<TKey, TValue>, ISerializationCallbackReceiver
{
    [SerializeField, HideInInspector]
    private List<TKey> keyData = new List<TKey>();

    [SerializeField, HideInInspector]
    private List<TValue> valueData = new List<TValue>();

    void ISerializationCallbackReceiver.OnAfterDeserialize()
    {
        this.Clear();
        for (int i = 0; i < this.keyData.Count && i < this.valueData.Count; i++)
        {
            this[this.keyData[i]] = this.valueData[i];
        }
    }

    void ISerializationCallbackReceiver.OnBeforeSerialize()
    {
        this.keyData.Clear();
        this.valueData.Clear();

        foreach (var item in this)
        {
            this.keyData.Add(item.Key);
            this.valueData.Add(item.Value);
        }
    }
}

public enum RPGActionType { SetVariables, Talk, PlaySFX, CallScript }

[Serializable]
public struct RPGAction
{
    public RPGActionType actionType;
    [ShowIf("actionType", RPGActionType.SetVariables)]
    public RPGVariableTable setVariableTable;
    [ShowIf("actionType", RPGActionType.Talk)]
    public string talkMSG;
    [ShowIf("actionType", RPGActionType.CallScript)]
    public UnityEvent callScript;
    [ShowIf("actionType", RPGActionType.PlaySFX)]
    public AudioClip playSFX;
}

[Serializable]
public class RPGVariableTable : RPGConditionTable
{
    public void Resolve()
    {
        foreach (var sw in switchTable) GameManager.SetSwitch(sw.ID(), sw.value);
        foreach (var va in variableTable)
        {
            switch (va.conditionality)
            {
                case VariableConditionality.Equals: GameManager.SetVariable(va.ID(), va.value); break;
                case VariableConditionality.GreaterThan: GameManager.AddToVariable(va.ID(), va.value); break;
                case VariableConditionality.LessThan: GameManager.AddToVariable(va.ID(), -va.value); break;
            }
        }
    }
}

[Serializable]
public class RPGConditionTable
{
    [TableList]
    [GUIColor(0, 1f, 0)]
    public List<UITableViewSwitch> switchTable = new List<UITableViewSwitch>();
    [Space]
    [TableList]
    [GUIColor(0, 0.85f, 0)]
    public List<UITableViewVariable> variableTable = new List<UITableViewVariable>();

    /// <summary>Refresh variable names if they have changed in .txt</summary>
    public void Refresh()
    {
        if (switchTable.Count > 0)
        {
            var switchLineList = new List<string>();
            foreach (var line in ReadSwitches())
            {
                switchLineList.Add(line);
            }
            foreach (var sw in switchTable)
            {
                if (sw.switchID == null) return;
                var ID = sw.switchID.Substring(0, 4);
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
            foreach (var line in ReadVariables())
            {
                variableLineList.Add(line);
            }
            foreach (var vr in variableTable)
            {
                if (vr.variableID == null) return;
                var ID = vr.variableID.Substring(0, 4);
                var txtID = variableLineList[int.Parse(ID)];
                if (txtID != vr.variableID)
                {
                    vr.variableID = txtID;
                }
            }
        }

    }

    IEnumerable<string> ReadSwitches()
    {
        var path = Application.dataPath + "/switches.txt";
        var dataLines = File.ReadAllLines(path);

        foreach (var line in dataLines)
        {
            yield return line;
        }
    }

    IEnumerable<string> ReadVariables()
    {
        var path = Application.dataPath + "/variables.txt";
        var dataLines = File.ReadAllLines(path);

        foreach (var line in dataLines)
        {
            yield return line;
        }
    }
}

[Serializable]
public class UITableViewSwitch
{
    [TableColumnWidth(120)]
    [ValueDropdown("ReadSwitches", IsUniqueList = true, DropdownTitle = "Select Switch", DropdownHeight = 400)]
    public string switchID;
    [TableColumnWidth(120)]
    public bool value = true;
    [TableColumnWidth(20)]
#if UNITY_EDITOR
    Rect rect;
    [Button("Rename")]
    void Edit()
    {
        PopupWindow.Show(rect, new UIPopupEditableVariableName(switchID, false));
    }
#endif

    public int ID()
    {
        return int.Parse(switchID.Substring(0, 4));
    }

    IEnumerable<string> ReadSwitches()
    {
        var path = Application.dataPath + "/switches.txt";
        var dataLines = File.ReadAllLines(path);

        foreach (var line in dataLines)
        {
            yield return line;
        }
    }


}

[Serializable]
public class UITableViewVariable
{
    [TableColumnWidth(140)]
    [ValueDropdown("ReadVariables", IsUniqueList = true, DropdownTitle = "Select Variable")]
    public string variableID;
    [ShowIf("variableID")]
    public VariableConditionality conditionality;
    [ShowIf("variableID")]
    public float value;
    [TableColumnWidth(20)]
#if UNITY_EDITOR
    Rect rect;
    [Button("Rename")]
    void Edit()
    {
        PopupWindow.Show(rect, new UIPopupEditableVariableName(variableID, true));
    }
#endif

    public int ID()
    {
        return int.Parse(variableID.Substring(0, 4));
    }

    IEnumerable ReadVariables()
    {
        var path = Application.dataPath + "/variables.txt";
        var dataLines = File.ReadAllLines(path);

        foreach (var line in dataLines)
        {
            yield return line;
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
        if (Selection.activeGameObject.TryGetComponent<RPGInteractable>(out var interactable)) foreach (var action in interactable.actions) action.setVariableTable.Refresh();
        if (Selection.activeGameObject.TryGetComponent<RPGEnabledByConditions>(out var c))
        {
            c.conditionTable.Refresh();
            c.conditionTableOR.Refresh();
        }
        editorWindow.Close();
    }

    void SaveNewSwitch(int ID, string newName, bool isVariable)
    {
        var path = Application.dataPath;
        path += isVariable ? "/variables.txt" : "/switches.txt";
        var dataLines = File.ReadAllLines(path);
        var textID = "";
        if (ID < 10) textID = "00" + ID;
        else if (ID < 100) textID = "0" + ID;
        dataLines[ID] = textID + " " + newName;
        File.WriteAllLines(path, dataLines);
    }

    IEnumerable<string> ReadSwitches()
    {
        var path = Application.dataPath + "/switches.txt";
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