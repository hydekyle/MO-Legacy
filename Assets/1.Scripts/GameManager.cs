using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Linq;
using UnityObservables;
using UnityEngine.Events;
using Sirenix.OdinInspector;
using UnityEngine.SceneManagement;
using Cysharp.Threading.Tasks;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    public GameData gameData;
    [HideInInspector]
    public Transform playerT;

    void Awake()
    {
        if (Instance) Destroy(this.gameObject);
        else
        {
            Instance = this;
            SceneManager.activeSceneChanged += OnActiveSceneChanged;
            DontDestroyOnLoad(this);
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F6)) SaveGameDataSlot(0);
        if (Input.GetKeyDown(KeyCode.F9)) LoadGameDataSlot(0);
    }

    private void OnActiveSceneChanged(Scene arg0, Scene arg1)
    {
        playerT = GameObject.Find("PLAYER").transform;
    }

    #region GameData
    public static bool GetSwitch(int ID)
    {
        try
        {
            return GameManager.Instance.gameData.switches[ID].Value;
        }
        catch
        {
            GameManager.SetSwitch(ID, false);
            return false;
        }
    }

    public static void SubscribeToSwitchChangedEvent(int ID, Action action)
    {
        GameManager.GetSwitch(ID); // This ensure the switch exist before sub
        GameManager.Instance.gameData.switches[ID].OnChanged += action;
    }

    public static void SubscribeToVariableChangedEvent(int ID, Action action)
    {
        GameManager.GetVariable(ID);
        GameManager.Instance.gameData.variables[ID].OnChanged += action;
    }

    public static void UnsubscribeToSwitchChangedEvent(int ID, Action action)
    {
        GameManager.Instance.gameData.switches[ID].OnChanged -= action;
    }

    public static void UnsubscribeToVariableChangedEvent(int ID, Action action)
    {
        GameManager.Instance.gameData.variables[ID].OnChanged -= action;
    }

    public static float GetVariable(int ID)
    {
        try
        {
            return GameManager.Instance.gameData.variables[ID].Value;
        }
        catch
        {
            GameManager.SetVariable(ID, 0);
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

    // Switches .txt Placeholder 
    // [Button("save")]
    // void WriteTest()
    // {
    //     var path = Application.dataPath + "/switches.txt";
    //     File.WriteAllLines(path, DameDatos());
    //     path = Application.dataPath + "/variables.txt";
    //     File.WriteAllLines(path, DameDatos());
    // }

    // IEnumerable<string> DameDatos()
    // {
    //     for (var x = 0; x < 200; x++)
    //     {
    //         var positionID = x.ToString();
    //         if (x < 10) positionID = "00" + positionID;
    //         else if (x < 100) positionID = "0" + positionID;
    //         yield return positionID + " ";
    //     }
    // }

    #endregion


}
