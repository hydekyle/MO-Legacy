using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Linq;
using UnityObservables;
using UnityEngine.Events;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    public GameData gameData;
    [HideInInspector]
    public UnityEvent onGameDataChanged;

    void OnValidate()
    {
        onGameDataChanged.Invoke();
    }

    void Awake()
    {
        if (Instance) Destroy(this);
        Instance = this;
        //DontDestroyOnLoad(this);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F6)) SaveGameDataSlot(0);
        if (Input.GetKeyDown(KeyCode.F9)) LoadGameDataSlot(0);
        if (Input.GetKeyDown(KeyCode.Space)) SwitchTest();
    }

    void SwitchTest()
    {
        SetSwitch("test2", !GetSwitch("test2"));
    }

    #region GameData
    public bool GetSwitch(string switchName)
    {
        try
        {
            return gameData.switches[switchName];
        }
        catch
        {
            return false;
        }
    }

    public int GetVariable(string variableName)
    {
        try
        {
            return gameData.variables[variableName];
        }
        catch
        {
            return 0;
        }
    }

    public void SetSwitch(string switchName, bool value)
    {
        gameData.switches[switchName] = value;
        onGameDataChanged.Invoke();
    }

    public void SetVariable(string variableName, int value)
    {
        gameData.variables[variableName] = value;
        onGameDataChanged.Invoke();
    }

    /// <summary>Saves GameManager Data in the user system</summary>
    public void SaveGameDataSlot(int slotIndex)
    {
        var fileName = "/savegame" + slotIndex;
        var savePath = string.Concat(Application.persistentDataPath, fileName);
        string saveData = JsonUtility.ToJson(this, true);
        BinaryFormatter bf = new BinaryFormatter();
        FileStream file = File.Create(savePath);
        bf.Serialize(file, saveData);
        file.Close();
        print("Game Save Success");
    }

    /// <summary>Load previous GameManager Data if exist</summary>
    public void LoadGameDataSlot(int slotIndex)
    {
        var fileName = "/savegame" + slotIndex;
        var savePath = string.Concat(Application.persistentDataPath, fileName);
        if (File.Exists(savePath))
        {
            print("Game Load Success");
            BinaryFormatter bf = new BinaryFormatter();
            FileStream file = File.Open(savePath, FileMode.Open);
            JsonUtility.FromJsonOverwrite(bf.Deserialize(file).ToString(), this);
        }
        else
        {
            Debug.Log("Starting New Game");
        }
    }
    #endregion

    /// <summary>This is for items like keys, it tries to find a trigger zone where a item is expected to be used</summary>
    public void CastUsableItem(Item item)
    {
        var player = GameObject.Find("Player"); //TODO: Avoid using Find
        var playerPosition = player.transform.position;
        var hit = Physics2D.CircleCast(playerPosition, 1f, Vector2.one, 1f, LayerMask.NameToLayer("Usable Item Zone"));
        if (hit.transform.TryGetComponent<UsableItemZone>(out UsableItemZone usableItemZone))
        {
            usableItemZone.UsedItem(item);
        }
    }

}
