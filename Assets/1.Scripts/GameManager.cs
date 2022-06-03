using System;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    public static GameData GameData { get { return GameManager.Instance._gameData; } }
    public static GameReferences refs = new();
    public TextManager textManager;
    public GameData _gameData = new();
    [HideInInspector]
    public static bool isMovementAvailable = true;
    public static bool isInteractAvailable = true;

    // void OnGUI()
    // {
    //     if (GUI.Button(new(0, 0, 100, 100), "Press me"))
    //     {
    //         cts.Cancel();
    //     }
    // }

    void Awake()
    {
        if (Instance) Destroy(this.gameObject);
        else
        {
            Instance = this;
            refs.player = GameObject.Find("PLAYER").GetComponent<Player>();
            refs.flashScreen = GameObject.Find("RPGFlashScreen").GetComponent<Image>();
            SceneManager.activeSceneChanged += OnActiveSceneChanged;
            transform.SetParent(null);
            DontDestroyOnLoad(this);
        }
    }

    void OnActiveSceneChanged(Scene arg0, Scene arg1)
    {
        try { SpawnPlayer(); } catch { print("No se encontraron Player Spawn Points"); }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F6)) _gameData.SaveGameDataSlot(0);
        if (Input.GetKeyDown(KeyCode.F9)) _gameData.LoadGameDataSlot(0).Forget();
        if (Input.GetKeyDown(KeyCode.F1)) Test();
    }

    private void Test()
    {
        textManager.SelectLanguage(textManager.availableLanguages[0]);
        print(textManager.ReadLine(1));
    }

    public void SpawnPlayer()
    {
        refs.player.LookAtDirection(_gameData.savedFaceDir);
        refs.player.transform.position = _gameData.savedMapSpawnIndex >= 0 ?
            GameObject.Find("[SPAWN]").transform.GetChild(_gameData.savedMapSpawnIndex).position
            : _gameData.savedPosition;
        CameraController.SetPosition(refs.player.transform.position);
    }

}
