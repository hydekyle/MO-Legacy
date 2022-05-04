using System.Collections.Generic;
using UnityEngine;
using System;
using UnityObservables;
using Sirenix.OdinInspector;
using Cysharp.Threading.Tasks;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine.SceneManagement;

public enum CollisionType { player, other, any }
public enum FaceDirection { North, West, East, South }
public enum VariableConditionality { Equals, GreaterThan, LessThan }
public enum TriggerType { PlayerInteraction, PlayerTouch, Autorun }
public enum FreezeType { None, FreezeMovement, FreezeInteraction, FreezeAll }

[Serializable]
public class PageEvent
{
    [PreviewField(50, ObjectFieldAlignment.Center)]
    public Sprite sprite;
    [GUIColor(0, 1, 1)]
    public VariableTable conditions;
    [GUIColor(1, 1, 0)]
    public List<RPGAction> actionList = new();
    [ShowIf("@this.actionList.Length > 0")]
    public TriggerType trigger = TriggerType.Autorun;
    [ShowIf("@this.actionList.Length > 0")]
    public FreezeType freezeWhile;
    [Space(25)]
    public AudioClip playSFXOnEnabled;
    bool isResolvingActionList = false;

    public async UniTaskVoid ResolveActionList()
    {
        if (isResolvingActionList) return;
        isResolvingActionList = true;
        DoFreezeWhile();
        for (var x = 0; x < actionList.Count; x++)
        {
            var action = actionList[x];
            await action.Resolve().AttachExternalCancellation(GameManager.CancelOnDestroyToken());
        }
        UnfreezeWhile();
        isResolvingActionList = false;
    }

    void DoFreezeWhile()
    {
        switch (freezeWhile)
        {
            case FreezeType.FreezeAll: GameManager.isInteractAvailable = GameManager.isMovementAvailable = false; break;
            case FreezeType.FreezeInteraction: GameManager.isInteractAvailable = false; break;
            case FreezeType.FreezeMovement: GameManager.isMovementAvailable = false; break;
        }
    }

    void UnfreezeWhile()
    {
        GameManager.isInteractAvailable = GameManager.isMovementAvailable = true;
    }
}

[Serializable]
public class GameData
{
    public SwitchDictionary switches = new();
    public VariableDictionary variables = new();
    public LocalVariableDictionary localVariableDic = new();
    public Inventory inventory = new();

    [HideInInspector]
    public string savedMapName;
    [HideInInspector]
    public int savedMapSpawnIndex;
    [HideInInspector]
    public Vector3 savedPosition;
    [HideInInspector]
    public FaceDirection savedFaceDir;

    public void AddItem(ScriptableItem item, int amount)
    {
        if (inventory.ContainsKey(item))
        {
            if (item.isStackable) inventory[item] += amount;
            else inventory[item] = amount;
        }
        else
            inventory.Add(item, amount);
    }

    public void SaveGameDataSlot(int slotIndex)
    {
        savedMapSpawnIndex = -1;
        savedPosition = GameManager.Instance.playerT.position;
        savedFaceDir = GameManager.Instance.playerT.GetComponent<Entity>().faceDirection;
        savedMapName = SceneManager.GetActiveScene().name;
        var fileName = "/savegame" + slotIndex;
        var savePath = string.Concat(Application.persistentDataPath, fileName);
        string saveData = JsonUtility.ToJson(this, true);
        BinaryFormatter bf = new BinaryFormatter();
        FileStream file = File.Create(savePath);
        bf.Serialize(file, saveData);
        file.Close();
    }

    public async UniTaskVoid LoadGameDataSlot(int slotIndex)
    {
        var fileName = "/savegame" + slotIndex;
        var savePath = string.Concat(Application.persistentDataPath, fileName);
        if (File.Exists(savePath))
        {
            BinaryFormatter bf = new BinaryFormatter();
            FileStream file = File.Open(savePath, FileMode.Open);
            JsonUtility.FromJsonOverwrite(bf.Deserialize(file).ToString(), this);
        }
        else
        {
            Debug.Log("Starting New Game");
        }
        //TODO: Remove when Title Menu is completed
        await SceneManager.LoadSceneAsync(savedMapName);
        var playerT = GameManager.Instance.playerT;
        playerT.position = savedPosition;
        playerT.GetComponent<Entity>().LookAtDirection(savedFaceDir);
    }

    public bool GetSwitch(int ID)
    {
        try
        {
            return switches[ID].Value;
        }
        catch
        {
            SetSwitch(ID, false);
            return false;
        }
    }

    public void SubscribeToSwitchChangedEvent(int ID, Action action)
    {
        GetSwitch(ID); // This ensure the switch exist before sub
        switches[ID].OnChanged += action;
    }

    public void SubscribeToVariableChangedEvent(int ID, Action action)
    {
        GetVariable(ID);
        variables[ID].OnChanged += action;
    }

    public void SubscribeToLocalVariableChangedEvent(int gameObjectID, Action action)
    {
        GetLocalVariable(gameObjectID);
        localVariableDic[gameObjectID].OnChanged += action;
    }

    public void UnsubscribeToSwitchChangedEvent(int ID, Action action)
    {
        switches[ID].OnChanged -= action;
    }

    public void UnsubscribeToVariableChangedEvent(int ID, Action action)
    {
        variables[ID].OnChanged -= action;
    }

    public void UnsubscribeToLocalVariableChangedEvent(int gameObjectID, Action action)
    {
        localVariableDic[gameObjectID].OnChanged -= action;
    }

    public float GetVariable(int ID)
    {
        try
        {
            return variables[ID].Value;
        }
        catch
        {
            SetVariable(ID, 0);
            return 0;
        }
    }

    public float GetLocalVariable(int gameObjectID)
    {
        try
        {
            return localVariableDic[gameObjectID].Value;
        }
        catch
        {
            SetLocalVariable(gameObjectID, 0);
            return 0;
        }
    }

    public void SetSwitch(int switchID, bool value)
    {
        if (switches.ContainsKey(switchID))
            switches[switchID].Value = value;
        else
            switches[switchID] = new Observable<bool>() { Value = value };
    }

    public void SetVariable(int variableID, float value)
    {
        if (variables.ContainsKey(variableID))
            variables[variableID].Value = value;
        else
            variables[variableID] = new Observable<float>() { Value = value };
    }

    public void AddToVariable(int variableID, float value)
    {
        if (variables.ContainsKey(variableID))
            variables[variableID].Value += value;
        else
            variables[variableID] = new Observable<float>() { Value = value };
    }

    public void SetLocalVariable(int gameObjectID, float value)
    {
        if (localVariableDic.ContainsKey(gameObjectID))
            localVariableDic[gameObjectID].Value = value;
        else
            localVariableDic[gameObjectID] = new Observable<float>() { Value = value };
    }

    public void AddToLocalVariable(int gameObjectID, float value)
    {
        if (localVariableDic.ContainsKey(gameObjectID))
            localVariableDic[gameObjectID].Value += value;
        else
            localVariableDic[gameObjectID] = new Observable<float>() { Value = value };
    }
}

#region Variables
[Serializable]
public class VariableTable
{
    [TableList]
    public List<UITableViewSwitch> switchTable = new List<UITableViewSwitch>();
    [Space]
    [TableList]
    public List<UITableViewVariable> variableTable = new List<UITableViewVariable>();
    [Space]
    [TableList]
    public List<UITableViewLocalVariable> localVariableTable = new List<UITableViewLocalVariable>();

    /// <summary>Refresh variable names if they have changed in .txt</summary>
    public void Refresh()
    {
        if (switchTable.Count > 0)
        {
            var switchLineList = new List<string>();
            foreach (var line in UIReadSwitchesFromTXT())
            {
                switchLineList.Add(line);
            }
            foreach (var sw in switchTable)
            {
                if (sw.switchID == null || sw.switchID == "") return;
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
            foreach (var line in UIReadVariablesFromTXT())
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

    IEnumerable<string> UIReadSwitchesFromTXT()
    {
        var path = Application.dataPath + "/switches.txt";
        var dataLines = File.ReadAllLines(path);

        foreach (var line in dataLines)
        {
            yield return line;
        }
    }

    IEnumerable<string> UIReadVariablesFromTXT()
    {
        var path = Application.dataPath + "/variables.txt";
        var dataLines = File.ReadAllLines(path);

        foreach (var line in dataLines)
        {
            yield return line;
        }
    }

    public void SubscribeToConditionTable(ref List<int> _subscribedSwitchList, ref List<int> _subscribedVariableList, ref List<int> _subscribedLocalVariableList, Action action)
    {
        foreach (var s in switchTable)
        {
            var ID = s.ID();
            if (_subscribedSwitchList.Contains(ID)) continue; // Avoiding resubscription
            GameManager.gameData.SubscribeToSwitchChangedEvent(ID, action);
            _subscribedSwitchList.Add(ID);
        }
        foreach (var v in variableTable)
        {
            var ID = v.ID();
            if (_subscribedVariableList.Contains(ID)) continue;
            GameManager.gameData.SubscribeToVariableChangedEvent(ID, action);
            _subscribedVariableList.Add(ID);
        }
        foreach (var lv in localVariableTable)
        {
            var ID = lv.ID();
            if (!_subscribedLocalVariableList.Contains(ID))
            {
                _subscribedLocalVariableList.Add(ID);
                GameManager.gameData.SubscribeToLocalVariableChangedEvent(ID, action);
            }
        }
    }

    public void UnsubscribeConditionTable(ref List<int> _subscribedSwitchList, ref List<int> _subscribedVariableList, ref List<int> _subscribedLocalVariableList, Action action)
    {
        foreach (var id in _subscribedLocalVariableList) GameManager.gameData.UnsubscribeToLocalVariableChangedEvent(id, action);
        foreach (var id in _subscribedSwitchList) GameManager.gameData.UnsubscribeToSwitchChangedEvent(id, action);
        foreach (var id in _subscribedVariableList) GameManager.gameData.UnsubscribeToVariableChangedEvent(id, action);
        _subscribedSwitchList.Clear();
        _subscribedVariableList.Clear();
    }

    public bool IsAllConditionOK()
    {
        foreach (var requiredLocalVariable in localVariableTable)
        {
            var variableValue = GameManager.gameData.GetLocalVariable(requiredLocalVariable.ID());
            switch (requiredLocalVariable.conditionality)
            {
                case VariableConditionality.Equals: if (requiredLocalVariable.value == variableValue) continue; break;
                case VariableConditionality.GreaterThan: if (requiredLocalVariable.value > variableValue) continue; break;
                case VariableConditionality.LessThan: if (requiredLocalVariable.value < variableValue) continue; break;
            }
            return false;
        }
        foreach (var requiredSwitch in switchTable)
        {
            var switchValue = GameManager.gameData.GetSwitch(requiredSwitch.ID());
            if (requiredSwitch.value != switchValue) return false;
        }
        foreach (var requiredVariable in variableTable)
        {
            var variableValue = GameManager.gameData.GetVariable(requiredVariable.ID());
            switch (requiredVariable.conditionality)
            {
                case VariableConditionality.Equals: if (requiredVariable.value == variableValue) continue; break;
                case VariableConditionality.GreaterThan: if (requiredVariable.value < variableValue) continue; break;
                case VariableConditionality.LessThan: if (requiredVariable.value > variableValue) continue; break;
            }
            return false;
        }
        return true;
    }
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

#endregion
#region Dictionaries
[Serializable] public class SwitchDictionary : UnitySerializedDictionary<int, Observable<bool>> { }
[Serializable] public class VariableDictionary : UnitySerializedDictionary<int, Observable<float>> { }
[Serializable] public class LocalVariableDictionary : UnitySerializedDictionary<int, Observable<float>> { }
[Serializable] public class Inventory : UnitySerializedDictionary<ScriptableItem, int> { }
public abstract class UnitySerializedDictionary<TKey, TValue> : Dictionary<TKey, TValue>, ISerializationCallbackReceiver
{
    // This class is required for Odin to serialize dictionaries
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
#endregion
