using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using Cysharp.Threading.Tasks;
using System.Threading;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    public GameData gameData;
    [HideInInspector]
    public Transform playerT;
    public static bool isMovementAvailable = true;
    public static bool isInteractAvailable = true;
    public static List<PageEvent> resolvingPageList = new List<PageEvent>();
    public static List<string> resolvingEntityIDList = new List<string>();

    void Awake()
    {
        if (Instance) Destroy(this.gameObject);
        else
        {
            Instance = this;
            SceneManager.activeSceneChanged += OnActiveSceneChanged;
            if (SceneManager.GetActiveScene().buildIndex != 0) playerT = GameObject.Find("PLAYER").transform;
            DontDestroyOnLoad(this);
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F6)) gameData.SaveGameDataSlot(0);
        if (Input.GetKeyDown(KeyCode.F9)) gameData.LoadGameDataSlot(0);
    }

    public static CancellationToken CancelOnDestroyToken()
    {
        return GameManager.Instance.GetCancellationTokenOnDestroy();
    }

    private void OnActiveSceneChanged(Scene arg0, Scene arg1)
    {
        playerT = GameObject.Find("PLAYER").transform;
        SpawnPlayer();
        CameraController.SetPosition(playerT.position);
    }

    public void SpawnPlayer()
    {
        if (playerT)
        {
            playerT.GetComponent<Entity>().LookAtDirection(gameData.savedFaceDir);
            playerT.position = gameData.savedMapSpawnIndex >= 0 ?
                GameObject.Find("[SPAWN]").transform.GetChild(gameData.savedMapSpawnIndex).position
                : gameData.savedPosition;
        }
    }

    public static async UniTaskVoid ResolveEntityActions(PageEvent page, GameObject entityGO)
    {
        var entityName = entityGO.name;
        if (GameManager.resolvingEntityIDList.Contains(entityName)) return;
        resolvingPageList.Add(page);
        resolvingEntityIDList.Add(entityName);
        OnResolvingPageListChanged();
        for (var x = 0; x < page.actions.Length; x++)
        {
            var action = page.actions[x];
            await action.Resolve().AttachExternalCancellation(GameManager.CancelOnDestroyToken());
        }
        resolvingPageList.Remove(page);
        resolvingEntityIDList.Remove(entityName);
        OnResolvingPageListChanged();
    }

    static void OnResolvingPageListChanged()
    {
        if (resolvingPageList.Count == 0)
        {
            isMovementAvailable = isInteractAvailable = true;
            return;
        }
        var pageList = resolvingPageList;
        if (pageList.Exists(item => item.run == RunType.FreezeAll)) isMovementAvailable = isInteractAvailable = false;
        else
        {
            if (pageList.Exists(item => item.run == RunType.FreezeInteraction)) isInteractAvailable = false;
            else isInteractAvailable = true;
            if (pageList.Exists(item => item.run == RunType.FreezeMovement)) isMovementAvailable = false;
            else isMovementAvailable = true;
        }
    }

}
