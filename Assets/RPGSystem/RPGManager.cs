using System;
using Doublsb.Dialog;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace RPGSystem
{
    [Serializable]
    public struct GameReferences
    {
        public Player player;
        public Image flashScreen;
    }

    [Serializable]
    public class RPGManager : MonoBehaviour
    {
        public static RPGManager Instance;

        public static AudioManager AudioManager { get => Instance.audioManager; }
        public AudioManager audioManager;

        public static GameReferences refs = new();
        public GameData gameData = new();

        bool isInteractionAvailable = true;
        bool isMovementAvailable = true;

        public FogData fogData;

        public bool IsInteractionAvailable() => isInteractionAvailable && DialogManager.Instance.state == State.Deactivate;
        public bool IsMovementAvailable() => isInteractionAvailable && DialogManager.Instance.state == State.Deactivate;

        void Awake()
        {
            if (Instance != null) Destroy(this.gameObject);
            else
            {
                Instance = this;
                DontDestroyOnLoad(this.gameObject);
                refs.player = GameObject.Find("PLAYER").GetComponent<Player>();
                refs.flashScreen = GameObject.Find("RPGFlashScreen").GetComponent<Image>();
                SceneManager.activeSceneChanged += OnActiveSceneChanged;
            }
        }

        void Update()
        {
            // Remove Dialog if opened
            if (Input.GetButtonDown("Interact") && DialogManager.Instance.Printer.activeSelf) DialogManager.Instance.Click_Window();

            // Save & Load
            if (Input.GetKeyDown(KeyCode.F6)) gameData.SaveGameDataSlot(0);
            if (Input.GetKeyDown(KeyCode.F9)) gameData.LoadGameDataSlot(0).Forget();
        }

        void OnActiveSceneChanged(Scene arg0, Scene arg1)
        {
            try { SpawnPlayer(); } catch { print("No se encontraron Player Spawn Points"); }
        }

        public void SpawnPlayer()
        {
            refs.player.LookAtDirection(gameData.savedFaceDir);
            refs.player.transform.position = gameData.savedMapSpawnIndex >= 0 ?
                GameObject.Find("[SPAWN]").transform.GetChild(gameData.savedMapSpawnIndex).position
                : gameData.savedPosition;
            CameraController.SetPosition(refs.player.transform.position);
        }

        public void SetPlayerFreeze(FreezeType freezeType)
        {
            switch (freezeType)
            {
                case FreezeType.FreezeAll: isInteractionAvailable = isMovementAvailable = false; break;
                case FreezeType.FreezeInteraction: isInteractionAvailable = false; isMovementAvailable = true; break;
                case FreezeType.FreezeMovement: isInteractionAvailable = true; isMovementAvailable = false; break;
                case FreezeType.None: isInteractionAvailable = isMovementAvailable = true; break;
            }
        }
    }

}