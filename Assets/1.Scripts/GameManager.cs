using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using Cysharp.Threading.Tasks;
using System.Threading;
using System;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    public static GameData gameData { get { return GameManager.Instance._gameData; } }
    public static GameReferences refMap = new();
    GameData _gameData = new();
    [HideInInspector]
    public static bool isMovementAvailable = true;
    public static bool isInteractAvailable = true;

    void Awake()
    {
        if (Instance) Destroy(this.gameObject);
        else
        {
            Instance = this;
            LoadGameReferences();
            SceneManager.activeSceneChanged += OnActiveSceneChanged;
            transform.SetParent(null);
            DontDestroyOnLoad(this);
        }
    }

    void OnActiveSceneChanged(Scene arg0, Scene arg1)
    {
        SpawnPlayer();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F6)) _gameData.SaveGameDataSlot(0);
        if (Input.GetKeyDown(KeyCode.F9)) _gameData.LoadGameDataSlot(0);
    }

    void LoadGameReferences()
    {
        refMap.player = GameObject.Find("PLAYER").GetComponent<Player>();
        refMap.flashScreen = GameObject.Find("RPGFlashScreen").GetComponent<Image>();
    }

    public static CancellationToken CancelOnDestroyToken()
    {
        return GameManager.Instance.GetCancellationTokenOnDestroy();
    }

    public void SpawnPlayer()
    {
        refMap.player.LookAtDirection(_gameData.savedFaceDir);
        refMap.player.transform.position = _gameData.savedMapSpawnIndex >= 0 ?
            GameObject.Find("[SPAWN]").transform.GetChild(_gameData.savedMapSpawnIndex).position
            : _gameData.savedPosition;
        CameraController.SetPosition(refMap.player.transform.position);
        //Camera.main.transform.position = new Vector3(refMap.player.transform.position.x, refMap.player.transform.position.y, -10);
    }



}
