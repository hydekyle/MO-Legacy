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

    [RequireComponent(typeof(AudioManager))]
    public class RPGManager : MonoBehaviour
    {
        public static RPGManager Instance;

        public static GameReferences Refs => Instance.refs;
        public static GameState GameState => Instance.gameState;
        public static bool IsInteractionAvailable => Instance.isInteractionAvailable && DialogManager.Instance.state == State.Deactivate;
        public static bool IsMovementAvailable => Instance.isMovementAvailable && DialogManager.Instance.state == State.Deactivate;

        public GameReferences refs = new();
        public GameState gameState = new();
        bool isInteractionAvailable = true;
        bool isMovementAvailable = true;

        public FogData fogData;

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

        void Start()
        {
            SpawnPlayer();
        }

        void Update()
        {
            // Save & Load
            if (Input.GetKeyDown(KeyCode.F6)) GameState.SaveGameStateSlot(0);
            if (Input.GetKeyDown(KeyCode.F9)) GameState.LoadGameStateSlot(0).Forget();
        }

        void OnActiveSceneChanged(Scene arg0, Scene arg1)
        {
            try { SpawnPlayer(); } catch { print("No se encontraron Player Spawn Points"); }
        }

        public void SpawnPlayer()
        {
            Refs.player.LookAtDirection(GameState.savedFaceDir);
            Refs.player.transform.position = GameObject.Find("[SPAWN]").transform.GetChild(GameState.savedMapSpawnIndex).position;
            CameraController.SetPosition(Refs.player.transform.position);
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