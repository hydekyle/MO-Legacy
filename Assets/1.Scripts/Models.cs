using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityObservables;
using Sirenix.OdinInspector;
using Cysharp.Threading.Tasks;
using System.IO;
using UnityEditor;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine.SceneManagement;

public enum CollisionType { player, other, any }
public enum FaceDirection { North, West, East, South }
public enum VariableConditionality { Equals, GreaterThan, LessThan }
public enum TriggerType { PlayerInteraction, PlayerTouch, Autorun }
public enum RunType { Parallel, FreezeMovement, FreezeInteraction, FreezeAll }

[System.Serializable]
public class ObsPage : Observable<List<RPGPage>> { }

[Serializable]
public struct RPGPage
{
    [PreviewField(50, ObjectFieldAlignment.Center)]
    public Sprite sprite;
    [GUIColor(0, 1, 1)]
    public RPGVariableTable conditions;
    [GUIColor(1, 1, 0)]
    public RPGAction[] actions;
    [ShowIf("@this.actions.Length > 0")]
    public TriggerType trigger;
    [ShowIf("@this.actions.Length > 0")]
    public RunType run;
    [Space(25)]
    public AudioClip playSFXOnEnabled;
}

public class Entity : MonoBehaviour
{
    public Sprite[] spriteList;
    public float movementSpeed;
    public float animationFrameTime = 0.1f;
    [HideInInspector]
    public FaceDirection faceDirection;
    SpriteRenderer spriteRenderer;
    float _lastTimeAnimationChanged = -1;
    int _indexStepAnim = 0;
    List<int> stepAnimOrder = new List<int>() { 0, 1, 2, 1 };
    public BoxCollider2D boxCollider2D;
    // 0 (down) walking
    // 1 (down) idle
    // 2 (down) walking
    // 3 (left) walking
    // 6 (right) walking
    // 9 (up) walking

    private void Awake()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        boxCollider2D = GetComponent<BoxCollider2D>();
    }

    Vector3 GetCastPoint()
    {
        var castPoint = boxCollider2D.bounds.center;
        var castDistance = 0.5f;
        switch (faceDirection)
        {
            case FaceDirection.North: castPoint += Vector3.up * castDistance; break;
            case FaceDirection.East: castPoint += Vector3.right * castDistance; break;
            case FaceDirection.West: castPoint += Vector3.left * castDistance; break;
            case FaceDirection.South: castPoint += Vector3.down * castDistance; break;
        }
        return castPoint;
    }

    public void CastInteraction()
    {
        var castPoint = GetCastPoint();
        var hits = Physics2D.CircleCastAll(castPoint, 0.3f, Vector2.one, 1f, LayerMask.GetMask("Default"));
        var _resolvedHits = new List<int>(); // Avoid reinteract when multiple collider
        foreach (var hit in hits)
        {
            var hitID = hit.transform.GetHashCode();
            if (_resolvedHits.Contains(hitID)) return;
            if (hit && hit.transform.TryGetComponent<RPGEvent>(out RPGEvent interactedEvent))
            {
                var page = interactedEvent.GetActivePage();
                if (page.trigger == TriggerType.PlayerInteraction)
                    GameManager.ResolveEntityActions(page, gameObject);
            }
            _resolvedHits.Add(hitID);
        }
        //LookAtDirection(GetFaceDirectionByMoveDirection(castPoint - transform.position));
    }

    public void CastUsableItem(ScriptableItem item)
    {
        var hit = Physics2D.CircleCast(GetCastPoint(), 1f, Vector2.one, 1f, LayerMask.GetMask("Usable Item Zone"));
        if (hit.transform.TryGetComponent<RPGUsableItemZone>(out RPGUsableItemZone usableItemZone))
        {
            usableItemZone.UsedItem(item);
        }
    }

    public void Move(Vector3 moveDirection)
    {
        transform.position = Vector3.Lerp(transform.position, transform.position + new Vector3(moveDirection.x, moveDirection.y, 0), Time.deltaTime * movementSpeed);
        AnimationWalk(moveDirection);
        spriteRenderer.sortingOrder = Helpers.GetSpriteOrderByPosition(transform.position);
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
            faceDirection = Entity.GetFaceDirectionByMoveDirection(moveDirection);
        }
    }

    public async UniTaskVoid StopMovement()
    {
        await UniTask.WaitUntil(() => _lastTimeAnimationChanged + animationFrameTime < Time.time, cancellationToken: GameManager.CancelOnDestroyToken());
        try { LookAtDirection(faceDirection); } catch { }
    }

    public void LookAtDirection(FaceDirection fDir)
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

    public static FaceDirection GetFaceDirectionByMoveDirection(Vector3 dir)
    {
        // Face priority by higher axis
        if (Mathf.Abs(dir.x) > Mathf.Abs(dir.y))
        {
            if (dir.x < 0) return FaceDirection.West;
            else if (dir.x > 0) return FaceDirection.East;
            else if (dir.y < 0) return FaceDirection.South;
            else return FaceDirection.North;
        }
        else
        {
            if (dir.y < 0) return FaceDirection.South;
            else if (dir.y > 0) return FaceDirection.North;
            else if (dir.x < 0) return FaceDirection.West;
            else return FaceDirection.East;
        }
    }

}

[Serializable]
public class GameData
{
    public SwitchDictionary switches;
    public VariableDictionary variables;
    public LocalVariableDictionary localVariableDic;
    public Inventory inventory = new Inventory();
    [HideInInspector]
    public int savedMapSpawnIndex;
    [HideInInspector]
    public Vector3 savedPosition;
    [HideInInspector]
    public FaceDirection savedFaceDir;

    public static void AddItem(ScriptableItem item, int amount)
    {
        if (GameManager.Instance.gameData.inventory.ContainsKey(item))
        {
            if (item.isStackable) GameManager.Instance.gameData.inventory[item] += amount;
            else GameManager.Instance.gameData.inventory[item] = amount;
        }
        else
            GameManager.Instance.gameData.inventory.Add(item, amount);
    }

    public void SaveGameDataSlot(int slotIndex)
    {
        savedMapSpawnIndex = -1;
        savedPosition = GameManager.Instance.playerT.position;
        savedFaceDir = GameManager.Instance.playerT.GetComponent<Entity>().faceDirection;
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
        await SceneManager.LoadSceneAsync(SceneManager.GetActiveScene().buildIndex);
        var playerT = GameManager.Instance.playerT;
        playerT.position = savedPosition;
        playerT.GetComponent<Entity>().LookAtDirection(savedFaceDir);
    }

    public static bool GetSwitch(int ID)
    {
        try
        {
            return GameManager.Instance.gameData.switches[ID].Value;
        }
        catch
        {
            GameData.SetSwitch(ID, false);
            return false;
        }
    }

    public static void SubscribeToSwitchChangedEvent(int ID, Action action)
    {
        GameData.GetSwitch(ID); // This ensure the switch exist before sub
        GameManager.Instance.gameData.switches[ID].OnChanged += action;
    }

    public static void SubscribeToVariableChangedEvent(int ID, Action action)
    {
        GameData.GetVariable(ID);
        GameManager.Instance.gameData.variables[ID].OnChanged += action;
    }

    public static void SubscribeToLocalVariableChangedEvent(int gameObjectID, Action action)
    {
        GameData.GetLocalVariable(gameObjectID);
        GameManager.Instance.gameData.localVariableDic[gameObjectID].OnChanged += action;
    }

    public static void UnsubscribeToSwitchChangedEvent(int ID, Action action)
    {
        GameManager.Instance.gameData.switches[ID].OnChanged -= action;
    }

    public static void UnsubscribeToVariableChangedEvent(int ID, Action action)
    {
        GameManager.Instance.gameData.variables[ID].OnChanged -= action;
    }

    public static void UnsubscribeToLocalVariableChangedEvent(int gameObjectID, Action action)
    {
        GameManager.Instance.gameData.localVariableDic[gameObjectID].OnChanged -= action;
    }

    public static float GetVariable(int ID)
    {
        try
        {
            return GameManager.Instance.gameData.variables[ID].Value;
        }
        catch
        {
            GameData.SetVariable(ID, 0);
            return 0;
        }
    }

    public static float GetLocalVariable(int gameObjectID)
    {
        try
        {
            return GameManager.Instance.gameData.localVariableDic[gameObjectID].Value;
        }
        catch
        {
            GameData.SetLocalVariable(gameObjectID, 0);
            return 0;
        }
    }

    public static void SetSwitch(int switchID, bool value)
    {
        if (GameManager.Instance.gameData.switches.ContainsKey(switchID))
            GameManager.Instance.gameData.switches[switchID].Value = value;
        else
            GameManager.Instance.gameData.switches[switchID] = new Observable<bool>() { Value = value };
    }

    public static void SetVariable(int variableID, float value)
    {
        if (GameManager.Instance.gameData.variables.ContainsKey(variableID))
            GameManager.Instance.gameData.variables[variableID].Value = value;
        else
            GameManager.Instance.gameData.variables[variableID] = new Observable<float>() { Value = value };
    }

    public static void AddToVariable(int variableID, float value)
    {
        if (GameManager.Instance.gameData.variables.ContainsKey(variableID))
            GameManager.Instance.gameData.variables[variableID].Value += value;
        else
            GameManager.Instance.gameData.variables[variableID] = new Observable<float>() { Value = value };
    }

    public static void SetLocalVariable(int gameObjectID, float value)
    {
        if (GameManager.Instance.gameData.localVariableDic.ContainsKey(gameObjectID))
            GameManager.Instance.gameData.localVariableDic[gameObjectID].Value = value;
        else
            GameManager.Instance.gameData.localVariableDic[gameObjectID] = new Observable<float>() { Value = value };
    }

    public static void AddToLocalVariable(int gameObjectID, float value)
    {
        if (GameManager.Instance.gameData.localVariableDic.ContainsKey(gameObjectID))
            GameManager.Instance.gameData.localVariableDic[gameObjectID].Value += value;
        else
            GameManager.Instance.gameData.localVariableDic[gameObjectID] = new Observable<float>() { Value = value };
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

[Serializable]
public class SwitchDictionary : UnitySerializedDictionary<int, Observable<bool>> { }

[Serializable]
public class VariableDictionary : UnitySerializedDictionary<int, Observable<float>> { }

[Serializable]
public class LocalVariableDictionary : UnitySerializedDictionary<int, Observable<float>> { }

[Serializable]
public class Inventory : UnitySerializedDictionary<ScriptableItem, int> { }

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

[Serializable]
public class RPGVariableTable
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
            foreach (var line in ReadSwitches())
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

    public void Resolve()
    {
        foreach (var lv in localVariableTable)
        {
            switch (lv.conditionality)
            {
                case VariableConditionality.Equals: GameData.SetLocalVariable(lv.ID(), lv.value); break;
                case VariableConditionality.GreaterThan: GameData.AddToLocalVariable(lv.ID(), lv.value); break;
                case VariableConditionality.LessThan: GameData.AddToLocalVariable(lv.ID(), -lv.value); break;
            }
        }
        foreach (var sw in switchTable) GameData.SetSwitch(sw.ID(), sw.value);
        foreach (var va in variableTable)
        {
            switch (va.conditionality)
            {
                case VariableConditionality.Equals: GameData.SetVariable(va.ID(), va.value); break;
                case VariableConditionality.GreaterThan: GameData.AddToVariable(va.ID(), va.value); break;
                case VariableConditionality.LessThan: GameData.AddToVariable(va.ID(), -va.value); break;
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
        var path = Application.dataPath + "/variables.txt";
        var dataLines = File.ReadAllLines(path);

        foreach (var line in dataLines)
        {
            yield return line;
        }
    }
}

[Serializable]
public class UITableViewLocalVariable
{
    [HorizontalGroup("target")]
    [TableColumnWidth(90)]
    [HideLabel]
    public GameObject target;
    [TableColumnWidth(30)]
    public float value;
    [VerticalGroup("target/btn")]
    [TableColumnWidth(90)]
    [Button("Self")]
    public void SaveID()
    {
        target = Selection.activeGameObject;
    }
    [HideLabel]
    public VariableConditionality conditionality;

    public int ID()
    {
        return target.GetHashCode();
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
                foreach (var action in page.actions) action.variableTable.Refresh();
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