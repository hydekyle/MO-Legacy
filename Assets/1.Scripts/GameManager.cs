using UnityEngine;
using UnityEngine.SceneManagement;
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
            refMap.player = GameObject.Find("PLAYER").GetComponent<Player>();
            refMap.flashScreen = GameObject.Find("RPGFlashScreen").GetComponent<Image>();
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
    }

    public void SpawnPlayer()
    {
        refMap.player.LookAtDirection(_gameData.savedFaceDir);
        refMap.player.transform.position = _gameData.savedMapSpawnIndex >= 0 ?
            GameObject.Find("[SPAWN]").transform.GetChild(_gameData.savedMapSpawnIndex).position
            : _gameData.savedPosition;
        CameraController.SetPosition(refMap.player.transform.position);
    }

}
